//
//  MainTableVC_TextViewDelegate.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 18..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

extension MainCollectionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeState(for: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeState(for: textView)
    }
    
    private func changeState(for textView: TextView) {
        guard let textView = textView as? GrowingTextView else { return }
        
        bottomView.emojiSearchButton.isHidden = textView.text.count != 0
        bottomView.writeButton.isHidden = textView.text.count == 0
        bottomView.writeButton.isEnabled = textView.text.count != 0
        
        if let position = textView.selectedTextRange?.end, textView.text.count != 0 {
            let caretOriginX = textView.caretRect(for: position).origin.x
            let textViewWidth = textView.bounds.width
            bottomView.emojiButton.isHidden = textViewWidth < 50 + caretOriginX
        }
        
    }

    private func filterNotes(with text: String) {
        guard text.count > 0 else { return }
        let request: NSFetchRequest<Emoji> = Emoji.fetchRequest()
        let predicates = Set(text.emojis)
            .map { $0.hashValue }
            .map { NSPredicate(format: "%K == %lld", #keyPath(Emoji.emojiHash), $0) }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        do {
            let results = try managedContext.fetch(request)
            let notes = results.compactMap { $0.notes }
                .compactMap { $0.allObjects as? [Note] }
                .reduce([], +)
            let predicates = notes.compactMap { $0.identifier }
                .map { NSPredicate(format: "%K == %@", #keyPath(Note.identifier), $0 as CVarArg) }
            noteFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        } catch {
            // TODO: error 처리
        }
    }
}

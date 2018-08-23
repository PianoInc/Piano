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
        filterNotes(with: textView.text)
        
        guard var bulletKey = BulletKey(text: textView.text, selectedRange: textView.selectedRange) else { return }
        
        switch bulletKey.type {
        case .orderedlist:
            textView.adjust(&bulletKey)
            textView.transform(bulletKey: bulletKey)
            textView.adjustAfter(&bulletKey)
        default:
            textView.transform(bulletKey: bulletKey)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let bulletValue = BulletValue(text: textView.text, selectedRange: textView.selectedRange) else { return true }
        
        if textView.shouldReset(bulletValue, shouldChangeTextIn: range, replacementText: text) {
            textView.reset(bulletValue, range: range)
            return true
        }
        
        if textView.shouldAdd(bulletValue, replacementText: text) {
            textView.add(bulletValue)
            return false
        }
        
        if textView.shouldDelete(bulletValue, replacementText: text) {
            textView.delete(bulletValue)
            return false
        }
        
        return true
    }
    
    private func changeState(for textView: TextView) {
        guard let textView = textView as? GrowingTextView else { return }
        
        bottomView.writeButton.isHidden = textView.text.count == 0
        bottomView.writeButton.isEnabled = textView.text.count != 0
        
        if let position = textView.selectedTextRange?.end, textView.text.count != 0 {
            let caretOriginX = textView.caretRect(for: position).origin.x
            let textViewWidth = textView.bounds.width
            bottomView.emojiButton.isHidden = textViewWidth < 50 + caretOriginX
        }
        
    }

    private func filterNotes(with text: String) {
        guard text.count > 0 else {
            noteFetchRequest.predicate = nil
            DispatchQueue.main.async { [weak self] in
                self?.refreshCollectionView()
            }
            return
        }
        // lexicalClass을 사용할 수 있으면
        if let language = NSLinguisticTagger.dominantLanguage(for: text),
            NSLinguisticTagger.availableTagSchemes(forLanguage: language).contains(.lexicalClass) {

            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            tagger.string = text

            let range = NSRange(location: 0, length: text.utf16.count)
            let options: NSLinguisticTagger.Options = [.omitWhitespace]
            let tags: [NSLinguisticTag] = [.noun, .verb, .otherWord, .number]
            var words = Array<String>()

            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in

                if let tag = tag, tags.contains(tag) {
                    let word = (text as NSString).substring(with: tokenRange)
                    words.append(word)
                }
            }
            let predicates = Set(words)
                .map { $0.lowercased() }
                .map { NSPredicate(format: "content contains[cd] %@", $0) }

            noteFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        } else {
            let trimmed = text.lowercased()
                .trimmingCharacters(in: .illegalCharacters)
                .trimmingCharacters(in: .punctuationCharacters)

            let predicate = NSPredicate(format: "content contains[cd] %@", trimmed)
            noteFetchRequest.predicate = predicate
        }

        DispatchQueue.main.async { [weak self] in
            self?.refreshCollectionView()
        }
    }
}

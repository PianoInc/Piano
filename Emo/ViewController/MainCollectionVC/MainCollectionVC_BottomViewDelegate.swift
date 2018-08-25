//
//  MainCollectionVC_BottomViewDelegate.swift
//  Emo
//
//  Created by hoemoon on 21/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import Foundation
import CoreData

extension MainCollectionViewController: BottomViewDelegate {
    
    func bottomView(_ bottomView: BottomView, didFinishTypingNote text: String) -> Note {
        let note = Note(context: mainContext)
        note.content = text
        note.createdDate = Date()
        note.modifiedDate = Date()
        return note
    }
    
    func bottomView(_ bottomView: BottomView, didFinishTypingPhoto text: String) -> Photo {
        //TODO: 사진 고르는 picker 모달로 뜨고, 중복 선택해서 완료 누르면 포토 객체 만들기
        return Photo()
    }
    
    func bottomView(_ bottomView: BottomView, didFinishTypingCalendar text: String) -> Calendar {
        //TODO: 캘린더 만들기
        return Calendar()
    }
    
    func bottomView(_ bottomView: BottomView, didFinishTypingReminder text: String) -> Reminder {
        //TODO: 리마인더 만들기
        return Reminder()
    }
    
    func bottomView(_ bottomView: BottomView, didFinishTypingEmail title: String?, body: String?) -> Email {
        //TODO: 이메일 만들고 전송하는 화면까지 띄워야함
        return Email()
    }
    
    func bottomView(_ bottomView: BottomView, didFinishTypingContact name: String?, num: String?, email: String?) -> Contact {
        //TODO: 연락처 만들기
        return Contact()
    }
    
    func bottomView(_ bottomView: BottomView, textViewDidChange textView: TextView) {
        typingCounter += 1
        perform(#selector(requestQuery(_:)), with: textView.text, afterDelay: searchRequestDelay)
    }
    
    func bottomView(_ bottomView: BottomView, didChangeTypingState state: TypingState) {
        setup(typingState: state)
    }

}

extension MainCollectionViewController {

    
    /// persistent store에 검색 요청하는 메서드.
    /// 검색할 문자열의 길이가 30보다 작을 경우,
    /// 0.3초 이상 멈추는 경우에만 실제로 요청한다.
    ///
    /// - Parameter sender: 검색할 문자열
    @objc func requestQuery(_ sender: Any?) {
        typingCounter -= 1
        guard let text = sender as? String,
            typingCounter == 0,
            text.count < 30  else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.refreshFetchRequest(with: text)
        }
    }
    
    private func refreshFetchRequest(with text: String) {
        guard text.count != 0 else {
            noteFetchRequest.predicate = nil
            DispatchQueue.main.async { [weak self] in
                self?.refreshCollectionView()
            }
            return
        }
        
        if let language = NSLinguisticTagger.dominantLanguage(for: text),
            NSLinguisticTagger.availableTagSchemes(forLanguage: language).contains(.lexicalClass) {
            
            linguisticRequest(with: text)
            
        } else {
            fullTextRequest(with: text)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshCollectionView()
        }
    }
    
    private func linguisticRequest(with text: String) {
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
    }
    
    private func fullTextRequest(with text: String) {
        let trimmed = text.lowercased()
            .trimmingCharacters(in: .illegalCharacters)
            .trimmingCharacters(in: .punctuationCharacters)
        
        let predicate = NSPredicate(format: "content contains[cd] %@", trimmed)
        noteFetchRequest.predicate = predicate
    }
}

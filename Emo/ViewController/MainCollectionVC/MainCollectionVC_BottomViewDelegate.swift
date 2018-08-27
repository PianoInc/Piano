//
//  MainCollectionVC_BottomViewDelegate.swift
//  Emo
//
//  Created by hoemoon on 21/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import Foundation
import CoreData
import CoreGraphics

extension MainCollectionViewController: BottomViewDelegate {
    
    enum BarButtonType: Int {
        case edit = 0
        case done = 1
    }
    
    func bottomView(_ bottomView: BottomView, keyboardWillShow height: CGFloat) {
        setDoneButtonIfNeeded()
    }
    
    func bottomView(_ bottomView: BottomView, keyboardWillHide height: CGFloat) {
        setEditButtonIfNeeded()
    }
    
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
        switch state {
        case .note:
            tapNote()
        case .calendar:
            tapCalendar()
        case .reminder:
            tapReminder()
        case .contact:
            tapContact()
        case .photo:
            tapPhoto()
        case .email:
            tapEmail()
        }
    }

    func emojies(_ bottomView: BottomView) -> [Emoji] {
        let request: NSFetchRequest<Emoji> = Emoji.fetchRequest()
        request.sortDescriptors = []
        if let emojies = try? backgroundContext.fetch(request) {
            return emojies
        }
        return []
    }
    typealias SearchReqeustMeta = (TypingState, String)

    func bottomView(_ bottomView: BottomView, textFieldDidChange textField: TextField, typingView: StackView) {
        if typingView is CalendarTypingView {
            typingCounter += 1
            let meta = SearchReqeustMeta(.calendar, textField.text ?? "")
            perform(#selector(requestQuery(_:)), with: meta, afterDelay: searchRequestDelay)
        }
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
        guard typingCounter == 0 else { return }

        if let text = sender as? String, text.count < 30 {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.refreshNoteFetchRequest(with: text)
            }
        }

        if let meta = sender as? SearchReqeustMeta {
            switch meta.0 {
            case .calendar:
                calendarManager?.refreshFetchRequest(with: meta.1)
            default:
                print()
            }
        }

    }
    
    private func refreshNoteFetchRequest(with text: String) {
        guard text.count != 0 else {
            noteFetchRequest.predicate = nil
            DispatchQueue.main.async { [weak self] in
                self?.refreshCollectionView()
            }
            return
        }

        noteFetchRequest.predicate = text.searchPredicate

        DispatchQueue.main.async { [weak self] in
            self?.refreshCollectionView()
        }
    }
}

extension MainCollectionViewController {
    private func setDoneButtonIfNeeded() {
        if let rightBarItem = navigationItem.rightBarButtonItem,
            let type = BarButtonType(rawValue: rightBarItem.tag),
            type != .done {
            navigationItem.setRightBarButton(doneBarButton, animated: true)
        }
    }
    
    private func setEditButtonIfNeeded() {
        if let rightBarItem = navigationItem.rightBarButtonItem,
            let type = BarButtonType(rawValue: rightBarItem.tag),
            type != .edit {
            navigationItem.setRightBarButton(editBarButton, animated: true)
        }
    }
}

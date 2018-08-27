//
//  CreateView.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 14..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol BottomViewDelegate: class {
    func bottomView(_ bottomView: BottomView, textViewDidChange textView: TextView)
    func bottomView(_ bottomView: BottomView, didChangeTypingState state: TypingState)
    
    func bottomView(_ bottomView: BottomView, didFinishTypingNote text: String) -> Note
    func bottomView(_ bottomView: BottomView, didFinishTypingReminder text: String) -> Reminder
    func bottomView(_ bottomView: BottomView, didFinishTypingCalendar text: String) -> Calendar
    func bottomView(_ bottomView: BottomView, didFinishTypingContact name: String?, num: String?, email: String?) -> Contact
    func bottomView(_ bottomView: BottomView, didFinishTypingPhoto text: String) -> Photo
    func bottomView(_ bottomView: BottomView, didFinishTypingEmail title: String?, body: String?) -> Email
    
    func bottomView(_ bottomView: BottomView, keyboardWillShow height: CGFloat)
    func bottomView(_ bottomView: BottomView, keyboardWillHide height: CGFloat)

    func emojies(_ bottomView: BottomView) -> [Emoji]
}

class BottomView: UIView {
    
    @IBOutlet weak var contextView: ContextView!
    @IBOutlet weak var noteTypingView: NoteTypingView!
    @IBOutlet weak var calendarTypingView: CalendarTypingView!
    @IBOutlet weak var reminderTypingView: ReminderTypingView!
    @IBOutlet weak var contactTypingView: ContactTypingView!
    @IBOutlet weak var photoTypingView: PhotoTypingView!
    @IBOutlet weak var emailTypingView: EmailTypingView!
    
    
    /** 키보드에 따른 위치 변화를 위한 컨스트레인트 */
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    /** 유저 인터렉션에 따라 자연스럽게 바텀뷰가 내려가게 하기 위한 옵저빙 토큰 */
    internal var keyboardToken: NSKeyValueObservation?
    internal var keyboardHeight: CGFloat?
    
    weak var mainViewController: BottomViewDelegate?
    var returnToNoteList: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyboardNotification()
    }
    
    deinit {
        unRegisterKeyboardNotification()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
}

extension BottomView {
    private func setup() {
        setHidden(typingState: .note)
        contextView.bottomView = self
        noteTypingView.bottomView = self
        calendarTypingView.bottomView = self
        reminderTypingView.bottomView = self
        contactTypingView.bottomView = self
        photoTypingView.bottomView = self
        emailTypingView.bottomView = self
    }
    
}


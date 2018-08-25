//
//  BottomView_ContextStackViewDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 24..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

//MARK: State
extension BottomView: ContextViewDelegate {
    func contextView(_ contextView: ContextView, didChangeTypingState state: TypingState) {
        setHidden(typingState: state)
        setBecomeFirstResponder(typingState: state)
        mainViewController?.bottomView(self, didChangeTypingState: state)
    }

}

extension BottomView {
    internal func setHidden(typingState: TypingState) {
        noteTypingView.isHidden = typingState != .note
        calendarTypingView.isHidden = typingState != .calendar
        reminderTypingView.isHidden = typingState != .reminder
        contactTypingView.isHidden = typingState != .contact
        photoTypingView.isHidden = typingState != .photo
        emailTypingView.isHidden = typingState != .email
    }
    
    private func setBecomeFirstResponder(typingState: TypingState) {
        switch typingState {
        case .note:
            noteTypingView.textView.becomeFirstResponder()
        case .calendar:
            calendarTypingView.textField.becomeFirstResponder()
        case .reminder:
            reminderTypingView.textField.becomeFirstResponder()
        case .contact:
            contactTypingView.nameTextField.becomeFirstResponder()
        case .photo:
            photoTypingView.textField.becomeFirstResponder()
        case .email:
            emailTypingView.titleTextField.becomeFirstResponder()
        }
    }
}

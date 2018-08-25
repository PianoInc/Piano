//
//  BottomView_ReminderTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: ReminderTypingViewDelegate {
    func reminderTypingView(_ reminderTypingView: ReminderTypingView, didFinishTyping text: String) {
        let reminder = delegate?.bottomView(self, didFinishTypingReminder: text)
        reminder?.detectEmojies()
        reminder?.saveIfNeeded()
        resetReminderTypingView()
    }
}

extension BottomView {
    private func resetReminderTypingView() {
        noteTypingView.textView.text = ""
        noteTypingView.textView.insertText("")
    }
}

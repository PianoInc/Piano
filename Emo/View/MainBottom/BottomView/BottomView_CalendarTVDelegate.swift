//
//  BottomView_CalendarTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: CalendarTypingViewDelegate {
    func calendarTypingView(_ calendarTyingView: CalendarTypingView, didFinishTyping text: String) {
        let calendar = mainViewController?.bottomView(self, didFinishTypingCalendar: text)
        calendar?.detectEmojies()
        calendar?.saveIfNeeded()
        resetCalendarTypingView()
    }
}

extension BottomView {
    private func resetCalendarTypingView() {
        calendarTypingView.textField.text = ""
        calendarTypingView.textField.insertText("")
    }
}

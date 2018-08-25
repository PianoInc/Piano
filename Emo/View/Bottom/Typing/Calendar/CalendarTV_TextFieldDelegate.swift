//
//  CalendarTypingView_TextFieldDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension CalendarTypingView: TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: TextField) {
        let isEnabled = textField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    @IBAction func textFieldEditingChanged(_ textField: TextField) {
        let isEnabled = textField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        bottomView?.calendarTypingView(self, didFinishTyping: textField.text ?? "")
        return true
    }
}

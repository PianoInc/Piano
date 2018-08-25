//
//  RTV_TextFieldDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension ReminderTypingView: TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: TextField) {
        let isEnabled = textField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    @IBAction func textFieldEditingChanged(_ textField: TextField) {
        let isEnabled = textField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        delegate?.reminderTypingView(self, didFinishTyping: textField.text ?? "")
        return true
    }
}

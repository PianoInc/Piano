//
//  EmailTV_TextFieldDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension EmailTypingView: TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: TextField) {
        //텍스트 필드 돌면서 텍스트 내용이 하나라도 있다면 true
        let isEnabled = titleTextField.text?.count != 0
            || bodyTextField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    @IBAction func textFieldEditingChanged(_ textField: TextField) {
        //텍스트 필드 돌면서 텍스트 내용이 하나라도 있다면 true
        let isEnabled = titleTextField.text?.count != 0
            || bodyTextField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == titleTextField {
            bodyTextField.becomeFirstResponder()
        } else {
            delegate?.emailTypingView(self, didFinishTyping: titleTextField.text, body: bodyTextField.text)
        }
        
        return true
    }
}

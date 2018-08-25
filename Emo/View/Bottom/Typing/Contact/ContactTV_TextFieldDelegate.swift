//
//  CTV_TextFieldDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension ContactTypingView: TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: TextField) {
        //텍스트 필드 돌면서 텍스트 내용이 하나라도 있다면 true
        let isEnabled = nameTextField.text?.count != 0
            || numberTextField.text?.count != 0
            || emailTextField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    @IBAction func textFieldEditingChanged(_ textField: TextField) {
        //텍스트 필드 돌면서 텍스트 내용이 하나라도 있다면 true
        let isEnabled = nameTextField.text?.count != 0
            || numberTextField.text?.count != 0
            || emailTextField.text?.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == nameTextField {
            numberTextField.becomeFirstResponder()
        } else if textField == numberTextField {
            emailTextField.becomeFirstResponder()
        } else {
            delegate?.contactTypingView(self,
                                        didFinishTyping: nameTextField.text,
                                        num: numberTextField.text,
                                        email: emailTextField.text)
        }
        return true
    }
}

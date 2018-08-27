//
//  BottomView_EmailTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: EmailTypingViewDelegate {
    func emailTypingView(_ emailTypingView: EmailTypingView, didFinishTyping title: String?, body: String?) {
        let email = mainViewController?.bottomView(self, didFinishTypingEmail: title, body: body)
        email?.detectEmojies()
        email?.saveIfNeeded()
        resetEmailTypingView()
    }
    
}

extension BottomView {
    private func resetEmailTypingView() {
        emailTypingView.titleTextField.text = ""
        emailTypingView.bodyTextField.text = ""
        emailTypingView.titleTextField.insertText("")
        emailTypingView.bodyTextField.insertText("")
    }
}

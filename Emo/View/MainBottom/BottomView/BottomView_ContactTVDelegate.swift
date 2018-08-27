//
//  BottomView_ContactTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: ContactTypingViewDelegate {
    func contactTypingView(_ contactTypingView: ContactTypingView, didFinishTyping name: String?, num: String?, email: String?) {
        let contact = mainViewController?.bottomView(self, didFinishTypingContact: name, num: num, email: email)
        contact?.detectEmojies()
        contact?.saveIfNeeded()
        resetContactTypingView()
    }

}

extension BottomView {
    private func resetContactTypingView() {
        contactTypingView.nameTextField.text = ""
        contactTypingView.numberTextField.text = ""
        contactTypingView.emailTextField.text = ""
        contactTypingView.nameTextField.insertText("")
        contactTypingView.numberTextField.insertText("")
        contactTypingView.emailTextField.insertText("")
    }
}

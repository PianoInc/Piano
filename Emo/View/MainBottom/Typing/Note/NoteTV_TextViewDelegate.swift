//
//  NoteTypingView_TextViewDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension NoteTypingView: TextViewDelegate {
    func textViewDidBeginEditing(_ textView: TextView) {
        let isEnabled = textView.text.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
    }
    
    func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let bulletValue = BulletValue(text: textView.text, selectedRange: textView.selectedRange) else { return true }
        
        if textView.shouldReset(bulletValue, shouldChangeTextIn: range, replacementText: text) {
            textView.reset(bulletValue, range: range)
            return true
        }
        
        if textView.shouldAdd(bulletValue, replacementText: text) {
            textView.add(bulletValue)
            return false
        }
        
        if textView.shouldDelete(bulletValue, replacementText: text) {
            textView.delete(bulletValue)
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: TextView) {
        let isEnabled = textView.text.count != 0
        setEnabled(button: writeButton, isEnabled: isEnabled)
        textView.convertBulletIfNeeded()
        bottomView?.noteTypingView(self, didChangeTextView: textView)
        
    }
}

extension NoteTypingView {
    internal func setWriteButtonEnabled(by text: String) {
        writeButton.isEnabled = text.count != 0
        writeButton.alpha = text.count != 0 ? 1 : 0
        
    }
}

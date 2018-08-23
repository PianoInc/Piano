//
//  BottomView_Action.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension BottomView {
    @IBAction func tapChangeContext(_ sender: UIButton) {
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        switchContextInputView(isSelected: isSelected)
    }
    
    @IBAction func tapWrite(_ sender: Any) {
        delegate?.didTapWriteButton(text: textView.text)
        textView.text = ""
        textView.delegate?.textViewDidChange!(textView)
    }
    
    @IBAction func tapEmoji(_ sender: UIButton) {
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        switchEmojiInputView(isSelected: isSelected)
    }
}

extension BottomView {
    private func switchEmojiInputView(isSelected: Bool) {
        if isSelected {
            emojiInputView.bounds.size.height = keyboardHeight ?? 100
            textView.inputView = emojiInputView
            textView.reloadInputViews()
        } else {
            textView.inputView = nil
            textView.reloadInputViews()
        }
    }
    
    private func switchContextInputView(isSelected: Bool) {
        if isSelected {
            contextInputView.bounds.size.height = keyboardHeight ?? 100
            textView.inputView = contextInputView
            textView.reloadInputViews()
        } else {
            textView.inputView = nil
            textView.reloadInputViews()
        }
    }
}

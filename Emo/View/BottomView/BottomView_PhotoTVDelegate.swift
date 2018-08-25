//
//  BottomView_PhotoTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: PhotoTypingViewDelegate {
    func photoTypingView(_ photoTypingView: PhotoTypingView, didFinishTyping text: String) {
        let photo = delegate?.bottomView(self, didFinishTypingPhoto: text)
        photo?.detectEmojies()
        photo?.saveIfNeeded()
        resetPhotoTypingView()
    }
    
    
}

extension BottomView {
    private func resetPhotoTypingView() {
        photoTypingView.textField.text = ""
        photoTypingView.textField.insertText("")
    }
}

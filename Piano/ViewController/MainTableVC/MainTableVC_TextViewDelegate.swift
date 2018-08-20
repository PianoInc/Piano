//
//  MainTableVC_TextViewDelegate.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 18..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension MainTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeState(for: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeState(for: textView)
    }
    
    private func changeState(for textView: TextView) {
        guard let textView = textView as? GrowingTextView else { return }
        
        bottomView.emojiSearchButton.isHidden = textView.text.count != 0
        bottomView.writeButton.isHidden = textView.text.count == 0
        
        if let position = textView.selectedTextRange?.end, textView.text.count != 0 {
            let caretOriginX = textView.caretRect(for: position).origin.x
            let textViewWidth = textView.bounds.width
            bottomView.emojiButton.isHidden = textViewWidth < 50 + caretOriginX
        }
        
    }
    
}

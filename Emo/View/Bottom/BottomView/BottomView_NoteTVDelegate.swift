//
//  BottomView_NoteTVDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BottomView: NoteTypingViewDelegate {
    
    func noteTypingView(_ noteTypingView: NoteTypingView, didFinishTyping text: String) {
        let note = mainViewController?.bottomView(self, didFinishTypingNote: text)
        note?.detectEmojies()
        note?.saveIfNeeded()
        resetNoteTypingView()
    }
    
    func noteTypingView(_ noteTypingView: NoteTypingView, didChangeTextView textView: TextView) {
        
        mainViewController?.bottomView(self, textViewDidChange: textView)
    }
    
}

extension BottomView {
    private func resetNoteTypingView() {
        noteTypingView.textView.text = ""
        noteTypingView.textView.insertText("")
    }
}

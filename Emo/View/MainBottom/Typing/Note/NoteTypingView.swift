//
//  NoteTypingView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol NoteTypingViewDelegate: class {
    func noteTypingView(_ noteTypingView: NoteTypingView, didFinishTyping text: String)
    func noteTypingView(_ noteTypingView: NoteTypingView, didChangeTextView textView: TextView)
}

class NoteTypingView: UIStackView {

    /** 텍스트를 입력받는 뷰, 텍스트가 변화할 때마다 모델이 업데이트된다(역반응) */
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var writeButton: UIButton!
    
    weak var bottomView: NoteTypingViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    @IBAction func write(_ sender: Any) {
        bottomView?.noteTypingView(self, didFinishTyping: textView.text)
    }
    
}

extension NoteTypingView {
    private func setup() {
        DispatchQueue.main.async { [weak self] in
            self?.textView.becomeFirstResponder()
        }
    }
}

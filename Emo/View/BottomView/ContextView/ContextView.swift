
//
//  ContextStackView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 24..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

enum TypingState: Int {
    case note = 0
    case calendar
    case reminder
    case contact
    case photo
    case email
}

protocol ContextViewDelegate: class {
    
    func contextView(_ contextView: ContextView, didChangeTypingState state: TypingState)
}


class ContextView: UIStackView {

    @IBOutlet var contextButtons: [UIButton]!
    private var emojiButtons: [UIButton] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateEmojiButtons()
    }
    
    weak var delegate: ContextViewDelegate?
    
    @IBAction func tapContextButton(_ sender: UIButton) {
        guard let typingState = TypingState(rawValue: sender.tag) else { return }
        setAlpha(typingState: typingState)
        delegate?.contextView(self, didChangeTypingState: typingState)
    }
    
    private func setAlpha(typingState: TypingState) {
        contextButtons.forEach{
            $0.alpha = typingState.rawValue != $0.tag ? 0.2 : 1
        }
    }

}

extension ContextView {
    internal func updateEmojiButtons() {
        //TODO: 코어데이터에서 이모지 삽입하기
    }
}

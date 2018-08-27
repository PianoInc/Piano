
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
    func contextView(_ contextView: ContextView, didTapEmoji emoji: String)
    func emojies(_ contextView: ContextView) -> [Emoji]
}


class ContextView: UIStackView {

    @IBOutlet var contextButtons: [UIButton]!
    private var emojiButtons: [UIButton] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateEmojiButtons()
    }
    
    weak var bottomView: ContextViewDelegate?
    
    @IBAction func tapContextButton(_ sender: UIButton) {
        guard let typingState = TypingState(rawValue: sender.tag) else { return }
        setAlpha(typingState: typingState)
        bottomView?.contextView(self, didChangeTypingState: typingState)
    }
    
    private func setAlpha(typingState: TypingState) {
        contextButtons.forEach{
            $0.alpha = typingState.rawValue != $0.tag ? 0.2 : 1
        }
    }

}

extension ContextView {
    internal func updateEmojiButtons() {
        guard let bottomView = bottomView else { return }
        for emoji in bottomView.emojies(self) {
            let button = UIButton()
            button.setTitle(emoji.string, for: UIControlState.normal)
            button.addTarget(self, action: #selector(tapEmoji(_:)), for: .touchUpInside)
            emojiButtons.append(button)
            addArrangedSubview(button)
        }
    }

    @objc func tapEmoji(_ button: UIButton?) {
        if let bottomView = bottomView,
            let button = button,
            let label = button.titleLabel,
            let emoji = label.text {

            bottomView.contextView(self, didTapEmoji: emoji)
        }
    }
}

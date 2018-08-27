
//
//  ContextView.swift
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
    func currentState(_ contextView: ContextView) -> TypingState?
    func contextView(_ contextView: ContextView, didChangeTypingState state: TypingState)
    func contextView(_ contextView: ContextView, didTapEmoji emoji: String, state: TypingState)
    func emojies(_ contextView: ContextView) -> [Emoji]
}


class ContextView: UIStackView {

    private var emojiButtons: [UIButton] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateEmojiButtons()
    }
    
    weak var bottomView: ContextViewDelegate?
    
    
    @IBAction func switchContext(_ sender: UISegmentedControl) {
        guard let typingState = TypingState(rawValue: sender.selectedSegmentIndex) else { return }
        bottomView?.contextView(self, didChangeTypingState: typingState)
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
            let emoji = label.text,
            let state = bottomView.currentState(self) {

            bottomView.contextView(self, didTapEmoji: emoji, state: state)
        }
    }
}

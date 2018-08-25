//
//  EmojiInputView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 24..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol EmojiInputViewDelegate: class {
    func emojiInputView(_ emojiInputView: EmojiInputView, didSelectItemAt indexPath: IndexPath)
}

class EmojiInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: EmojiInputViewDelegate?

}

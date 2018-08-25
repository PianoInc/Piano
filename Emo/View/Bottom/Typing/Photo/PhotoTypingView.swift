//
//  PhotoTypingView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol PhotoTypingViewDelegate: class {
    func photoTypingView(_ photoTypingView: PhotoTypingView, didFinishTyping text: String)
}

class PhotoTypingView: UIStackView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var writeButton: UIButton!
    weak var bottomView: PhotoTypingViewDelegate?
    
    @IBAction func write(_ sender: Any) {
        bottomView?.photoTypingView(self, didFinishTyping: textField.text ?? "")
    }

}

//
//  EmailTypingView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol EmailTypingViewDelegate: class {
    func emailTypingView(_ emailTypingView: EmailTypingView, didFinishTyping title: String?, body: String?)
}


class EmailTypingView: UIStackView {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    @IBOutlet weak var writeButton: UIButton!
    weak var delegate: EmailTypingViewDelegate?
    
    @IBAction func write(_ sender: Any) {
        delegate?.emailTypingView(self, didFinishTyping: titleTextField.text, body: bodyTextField.text)
    }
}

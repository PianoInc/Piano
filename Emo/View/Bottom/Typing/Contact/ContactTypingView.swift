//
//  ContactTypingView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 24..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol ContactTypingViewDelegate: class {
    func contactTypingView(_ contactTypingView: ContactTypingView, didFinishTyping name: String?, num: String?, email: String?)
}

class ContactTypingView: UIStackView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var writeButton: UIButton!
    weak var delegate: ContactTypingViewDelegate?
    
    @IBAction func write(_ sender: Any) {
        delegate?.contactTypingView(self, didFinishTyping: nameTextField.text, num: numberTextField.text, email: emailTextField.text)
    }

}

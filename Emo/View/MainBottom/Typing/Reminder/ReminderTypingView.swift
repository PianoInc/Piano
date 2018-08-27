//
//  ReminderStackView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 24..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol ReminderTypingViewDelegate: class {
    func reminderTypingView(_ reminderTypingView: ReminderTypingView, didFinishTyping text: String)
}

class ReminderTypingView: UIStackView {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var writeButton: UIButton!
    weak var bottomView: ReminderTypingViewDelegate?
    
    @IBAction func write(_ sender: Any) {
        bottomView?.reminderTypingView(self, didFinishTyping: textField.text ?? "")
    }
}

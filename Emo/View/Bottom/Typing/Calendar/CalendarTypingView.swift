//
//  CalendarTypingView.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol CalendarTypingViewDelegate: class {
    func calendarTypingView(_ calendarTypingView: CalendarTypingView, didFinishTyping text: String)
    func calendarTypingView(_ calendarTypingView: CalendarTypingView, didBeginTyping text: String)
}

class CalendarTypingView: UIStackView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var writeButton: UIButton!
    weak var delegate: CalendarTypingViewDelegate?
    
    @IBAction func write(_ sender: Any) {
        delegate?.calendarTypingView(self, didFinishTyping: textField.text ?? "")
    }
    
    

}

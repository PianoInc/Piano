//
//  ReminderCollectionViewCell.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import EventKit

class ReminderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    func configure(_ reminder: EKReminder) {
        checkButton.isSelected = reminder.isCompleted
        label.text = reminder.title
        eventDateLabel.text = ""
        if let date = reminder.alarms?.first?.absoluteDate {
            let format = DateFormatter()
            format.dateFormat = "yyyy. MM. dd. hh:mm aa"
            eventDateLabel.text = format.string(from: date)
        }
    }
    
    @IBAction func check(_ sender: UIButton) {
        let isSelected = !sender.isSelected
        sender.isSelected = isSelected
        
        
    }
    
}

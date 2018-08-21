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
    
    func configure(_ calendarItem: EKCalendarItem) {
        
    }
    
}

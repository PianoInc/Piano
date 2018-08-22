//
//  CalendarCollectionViewCell.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import EventKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    func configure(_ event: EKEvent) {
        let calendar = Foundation.Calendar(identifier: .gregorian)
        let interval = calendar.dateComponents([.day], from: event.startDate, to: event.endDate).day ?? 0
        dDayLabel.text = "\((interval == 0) ? "D-day" : "-" + String(interval))"
        titleLabel.text = event.title
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd. hh:mm aa"
        startDateLabel.text = format.string(from: event.startDate)
        endDateLabel.text = format.string(from: event.endDate)
    }
    
}

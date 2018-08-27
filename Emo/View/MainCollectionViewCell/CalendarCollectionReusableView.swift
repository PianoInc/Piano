//
//  CalendarCollectionReusableView.swift
//  Emo
//
//  Created by JangDoRi on 2018. 8. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class CalendarCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
    
}

//
//  NoteDetailVC_Action.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension NoteDetailViewController {
    
    @IBAction func switchSegmentControl(_ sender: UISegmentedControl) {
        if sender.isSelected {
            sender.isSelected = false
        }
    }
}

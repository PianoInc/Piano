//
//  BottomToolbar.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol DetailBottomViewDelegate: class {
    func detailBottomView(_ detailBottomView: DetailBottomView, didSelectSegmentControl index: Int)
    func detailBottomView(_ detailBottomView: DetailBottomView, keyboardWillShow height: CGFloat)
    func detailBottomView(_ detailBottomView: DetailBottomView, keyboardWillHide height: CGFloat)
}

class DetailBottomView: UIView {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    internal var keyboardToken: NSKeyValueObservation?
    internal var keyboardHeight: CGFloat?

    weak var noteDetailViewController: DetailBottomViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerKeyboardNotification()
    }
    
    deinit {
        unRegisterKeyboardNotification()
    }
    
    
    
    
    
    
    @IBAction func switchControl(_ sender: UISegmentedControl) {
        noteDetailViewController?.detailBottomView(self, didSelectSegmentControl: sender.selectedSegmentIndex)
    }

}

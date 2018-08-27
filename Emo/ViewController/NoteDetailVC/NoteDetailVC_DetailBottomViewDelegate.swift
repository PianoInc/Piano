//
//  NoteDetailVC_DetailBottomViewDelegate.swift
//  Emo
//
//  Created by Kevin Kim on 2018. 8. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension NoteDetailViewController: DetailBottomViewDelegate {
    func detailBottomView(_ detailBottomView: DetailBottomView, keyboardWillHide height: CGFloat) {
        setHighlightBarButtonIfNeeded()
    }
    
    func detailBottomView(_ detailBottomView: DetailBottomView, keyboardWillShow height: CGFloat) {
        setDoneBarButtonIfNeeded()
    }
    
    func detailBottomView(_ detailBottomView: DetailBottomView, didSelectSegmentControl index: Int) {
        ()
    }
}

extension NoteDetailViewController {
    
    enum BarButtonType: Int {
        case edit = 0
        case done = 1
    }
    
    private func setDoneBarButtonIfNeeded() {
        if let rightBarItem = navigationItem.rightBarButtonItem,
            let type = BarButtonType(rawValue: rightBarItem.tag),
            type != .done {
            navigationItem.setRightBarButton(doneBarButton, animated: true)
        }
    }
    
    private func setHighlightBarButtonIfNeeded() {
        if let rightBarItem = navigationItem.rightBarButtonItem,
            let type = BarButtonType(rawValue: rightBarItem.tag),
            type != .edit {
            navigationItem.setRightBarButton(highlightBarButton, animated: true)
        }
    }
}

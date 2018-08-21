//
//  MainCollectionVC_BottomViewDelegate.swift
//  Piano
//
//  Created by hoemoon on 21/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import Foundation

extension MainCollectionViewController: BottomViewDelegate {
    func didTapWriteButton(text: String) {
        guard text.count > 0 else { return }
        let note = Note(context: managedContext)
        note.content = text


        saveContext()
    }
}

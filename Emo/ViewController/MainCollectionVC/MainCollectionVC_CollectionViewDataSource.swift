//
//  MainTableVC_CollectionViewDataSource.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 18..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension MainCollectionViewController: CollectionViewDataSource {
    
//    var typingState: TypingState {
//        if reminderManager != nil {
//            return .reminder
//        } else if calendarManager != nil {
//            return .calendar
//        } else if contactManager != nil {
//            return .contact
//        } else if photoManager != nil {
//            return .photo
//        } else {
//            return .note
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
        configure(noteCell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configure(noteCell: NoteCollectionViewCell, indexPath: IndexPath) {
        let note = resultsController?.object(at: indexPath)
        noteCell.contentLabel.text = note?.content
        if let date = note?.modifiedDate {
            noteCell.dateLabel.text = DateFormatter.sharedInstance.string(from: date)
        }
    }
}

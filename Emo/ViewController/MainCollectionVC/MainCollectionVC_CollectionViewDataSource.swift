//
//  MainTableVC_CollectionViewDataSource.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 18..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension MainCollectionViewController: CollectionViewDataSource {
    
    var type: VCType {
        if reminderDataSource != nil {
            return .reminder
        } else if calendarDataSource != nil {
            return .calendar
        } else if contactDataSource != nil {
            return .contact
        } else if photoDataSource != nil {
            return .photo
        } else {
            return .note
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .note:
            return resultsController?.sections?[section].numberOfObjects ?? 0
        case .calendar:
            return calendarDataSource?.count ?? 0
        case .contact:
            return contactDataSource?.count ?? 0
        case .photo:
            return photoDataSource?.count ?? 0
        case .reminder:
            return reminderDataSource?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .note:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
            configure(noteCell: cell, indexPath: indexPath)
            return cell
        case .calendar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
            configure(calendarCell: cell, indexPath: indexPath)
            return cell
        case .contact:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
            configure(calendarCell: cell, indexPath: indexPath)
            return cell
        case .photo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
            configure(calendarCell: cell, indexPath: indexPath)
            return cell
            
        case .reminder:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
            configure(calendarCell: cell, indexPath: indexPath)
            return cell
        
        }
    }
    
    private func configure(noteCell: NoteCollectionViewCell, indexPath: IndexPath) {
        
    }
    
    private func configure(calendarCell: CalendarCollectionViewCell, indexPath: IndexPath) {
        
    }
    
    private func configure(contactCell: ContactCollectionViewCell, indexPath: IndexPath) {
        
    }
    
    private func configure(photoCell: PhotoCollectionViewCell, indexPath: IndexPath) {
        
    }
    
    
}

//
//  MainTableVC_Action.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

extension MainCollectionViewController {
    
    enum VCType {
        case note
        case calendar
        case reminder
        case contact
        case photo
    }
    
    @IBAction func tapCalendar(_ sender: Any) {
        setup(for: .calendar)
    }
    
    @IBAction func tapReminder(_ sender: Any) {
        setup(for: .reminder)
    }
    
    @IBAction func tapContact(_ sender: Any) {
        setup(for: .contact)
    }
    
    @IBAction func tapPhoto(_ sender: Any) {
        setup(for: .photo)
    }
}

extension MainCollectionViewController {
    private func setup(for vcType: VCType) {
        
        createSnapShotAndAnimate()
        
        DispatchQueue.main.async { [weak self] in
            self?.bottomView.resetInputView()
            self?.setupNavigationBar(for: vcType)
            self?.setupDataSource(for: vcType)
            self?.collectionView.reloadData()
        }
    }
    
    private func setupNavigationBar(for vcType: VCType) {
        switch vcType {
        case .note:
            navigationItem.titleView = titleView
        default:
            navigationItem.titleView = segmentControl
        }
    }
    
    //TODO: 데이터 타입에 따른 데이터 소스 생성하기
    private func setupDataSource(for vcType: VCType) {
        setNilAllDataSources()
        
        switch vcType {
        case .note:
            resultsController = createNoteResultsController()
        case .calendar:
            calendarDataSource = fetchCalendarDataSource()
        case .reminder:
            reminderDataSource = fetchReminderDataSource()
        case .contact:
            contactDataSource = fetchContactDataSource()
        case .photo:
            photoDataSource = fetchPhotoDataSource()
        }
    }
    
    private func setNilAllDataSources() {
        calendarDataSource = nil
        reminderDataSource = nil
        contactDataSource = nil
        resultsController = nil
    }
    
    private func createSnapShotAndAnimate() {
        
    }
    
    private func fetchCalendarDataSource() -> [String] {
        return ["hello"]
    }
    
    private func fetchReminderDataSource() -> [String] {
        return ["hello"]
    }
    
    private func fetchContactDataSource() -> [String] {
        return ["hello"]
    }
    
    private func fetchPhotoDataSource() -> [String] {
        return ["hello"]
    }
    
    internal func createNoteResultsController() -> NSFetchedResultsController<Note> {
        let a = NSFetchedResultsController<Note>()
        return a
    }
    
    internal func setupCollectionViewLayout(for type: VCType) {
        //TODO: 임시로 해놓은 것이며 세팅해놓아야함
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
    }
    
}

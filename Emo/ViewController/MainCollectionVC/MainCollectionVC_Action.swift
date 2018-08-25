//
//  MainTableVC_Action.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import Photos
import Contacts

extension MainCollectionViewController {
    
    @IBAction func tapSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            contactManager?.fetchAll()
            reminderManager?.fetchAll()
            calendarManager?.fetchAll()
        default:
            contactManager?.fetch()
            reminderManager?.fetch()
            calendarManager?.fetch()
        }
    }
    
    @IBAction func tapCalendar(_ sender: Any) {
        auth(check: .calendar) { [weak self] in
            self?.setup(typingState: .calendar)
        }
    }
    
    @IBAction func tapPhoto(_ sender: Any) {
        auth(check: .photo) { [weak self] in
            self?.setup(typingState: .photo)
        }
    }
    
    @IBAction func tapReminder(_ sender: Any) {
        auth(check: .reminder) {  [weak self] in
            self?.setup(typingState: .reminder)
        }
    }
    
    @IBAction func tapContact(_ sender: Any) {
        auth(check: .contact) {  [weak self] in
            self?.setup(typingState: .contact)
        }
    }
    
    private func auth(check type: TypingState, _ completion: @escaping (() -> ())) {
        switch type {
        case .calendar, .reminder:
            let type: EKEntityType = (type == .calendar) ? .event : .reminder
            let message = (type == .event) ? "달력 권한 주세요." : "미리알림 권한 주세요."
            switch EKEventStore.authorizationStatus(for: type) {
            case .notDetermined:
                EKEventStore().requestAccess(to: type) { status, error in
                    DispatchQueue.main.async {
                        switch status {
                        case true : completion()
                        case false : self.eventAuth(alert: message)
                        }
                    }
                }
            case .authorized: completion()
            case .restricted, .denied: eventAuth(alert: message)
            }
        case .photo:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized: completion()
                    default: self.eventAuth(alert: "사진 권한 주세요.")
                    }
                }
            }
        default:
            CNContactStore().requestAccess(for: .contacts) { status, error in
                DispatchQueue.main.async {
                    switch status {
                    case true: completion()
                    case false: self.eventAuth(alert: "연락처 권한 주세요.")
                    }
                }
            }
        }
    }
    
    private func eventAuth(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        present(alert, animated: true)
    }
    
}

extension MainCollectionViewController {
    
    func setup(typingState: TypingState) {
        createSnapShotAndAnimate()
        DispatchQueue.main.async { [weak self] in
            self?.setupNavigationBar(typingState: typingState)
            self?.setupDataSource(typingState: typingState)
            self?.collectionView.reloadData()
        }
    }
    
    private func setupNavigationBar(typingState: TypingState) {
        switch typingState {
        case .note, .photo:
            navigationItem.titleView = titleView
        default:
            navigationItem.titleView = segmentControl
        }
    }
    
    //TODO: 데이터 타입에 따른 데이터 소스 생성하기
    private func setupDataSource(typingState: TypingState) {
        switch typingState {
        case .note:
            collectionView.dataSource = self
            collectionView.delegate = self
        case .calendar:
            calendarManager = CalendarManager<CalendarCollectionViewCell>(self, collectionView)
            calendarManager?.fetchAll()
        case .reminder:
            reminderManager = ReminderManager<ReminderCollectionViewCell>(self, collectionView)
            reminderManager?.fetchAll()
        case .contact:
            contactManager = ContactManager<ContactCollectionViewCell>(self, collectionView)
            contactManager?.fetchAll()
        case .photo:
            photoManager = PhotoManager<PhotoCollectionViewCell>(self, collectionView)
            photoManager?.fetchAll()
        case .email:
            ()
            //TODO: 이메일 연동
        }
    }
    
    private func createSnapShotAndAnimate() {
        
    }
    
    internal func createNoteResultsController() -> NSFetchedResultsController<Note> {
        let controller = NSFetchedResultsController(
            fetchRequest: noteFetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: "Note"
        )
        return controller
    }
    
    internal func setupCollectionViewLayout(for type: TypingState) {
        //TODO: 임시로 해놓은 것이며 세팅해놓아야함
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
    }
    
}

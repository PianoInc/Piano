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
    
    enum VCType {
        case note
        case calendar
        case reminder
        case contact
        case photo
    }
    
    @IBAction func tapCalendar(_ sender: Any) {
        auth(check: .calendar) { [weak self] in
            self?.setup(for: .calendar)
        }
    }
    
    
    @IBAction func tapPhoto(_ sender: Any) {
        auth(check: .photo) { [weak self] in
            self?.setup(for: .photo)
        }
    }
    
    @IBAction func tapReminder(_ sender: Any) {
        auth(check: .reminder) {  [weak self] in
            self?.setup(for: .reminder)
        }
    }
    
    @IBAction func tapContact(_ sender: Any) {
        auth(check: .contact) {  [weak self] in
            self?.setup(for: .contact)
        }
    }
    
    @IBAction func tapPhotos(_ sender: Any) {
        auth(check: .photo) {  [weak self] in
            self?.setup(for: .photo)
        }
    }
    
    private func auth(check type: CollectionViewType, _ completion: @escaping (() -> ())) {
        if type == .calendar || type == .reminder {
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
        } else if type == .photo {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized: completion()
                    default: self.eventAuth(alert: "사진 권한 주세요.")
                    }
                }
            }
        } else {
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
    
    enum CollectionViewType {
        case note
        case calendar
        case reminder
        case contact
        case photo
    }
    
    private func reloadCollectionView(for type: CollectionViewType) {
        switch type {
        case .calendar: CalendarDatasource<CalendarCollectionViewCell>(self, collectionView).fetch()
        case .reminder: ReminderDatasource<ReminderCollectionViewCell>(self, collectionView).fetch()
        case .contact: ContactDatasource<ContactCollectionViewCell>(self, collectionView).fetch()
        case .photo: break
        default: break
        }
        bottomView.textView.inputView = nil
        reloadInputViews()
    }

}

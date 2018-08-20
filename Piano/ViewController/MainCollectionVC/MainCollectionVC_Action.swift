//
//  MainTableVC_Action.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import EventKit
import Photos
import Contacts

extension MainCollectionViewController {
    
    @IBAction func tapCalendar(_ sender: Any) {
        auth(check: .calendar) {self.reloadCollectionView(for: .calendar)}
    }
    
    @IBAction func tapReminder(_ sender: Any) {
        auth(check: .reminder) {self.reloadCollectionView(for: .reminder)}
    }
    
    @IBAction func tapContact(_ sender: Any) {
        auth(check: .contact) {self.reloadCollectionView(for: .contact)}
    }
    
    @IBAction func tapPhotos(_ sender: Any) {
        auth(check: .photos) {self.reloadCollectionView(for: .photos)}
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
        } else if type == .photos {
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
    
    enum CollectionViewType {
        case note
        case calendar
        case reminder
        case contact
        case photos
    }
    
    private func reloadCollectionView(for type: CollectionViewType) {
        switch type {
        case .calendar: CalendarDatasource<CalendarCollectionViewCell>(self, collectionView).fetch()
        case .reminder: ReminderDatasource<ReminderCollectionViewCell>(self, collectionView).fetch()
        case .contact: ContactDatasource<ContactCollectionViewCell>(self, collectionView).fetch()
        case .photos: break
        default: break
        }
        bottomView.textView.inputView = nil
        reloadInputViews()
    }
    
}

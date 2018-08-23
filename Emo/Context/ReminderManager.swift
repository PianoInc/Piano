//
//  ReminderManager.swift
//  Piano
//
//  Created by JangDoRi on 2018. 8. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class ReminderManager<Cell: ReminderCollectionViewCell>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private weak var viewController: UIViewController!
    private weak var collectionView: UICollectionView!
    
    private let eventStore = EKEventStore()
    private var fetchRC: NSFetchedResultsController<Reminder>?
    private var fetchData: [EKReminder]?
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        fetchData = nil
        collectionView.reloadData()
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.fetchLimit = 20
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Reminder.identifiers), ascending: true)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Reminder")
        fetchRC?.delegate = self
    }
    
    func fetchAll() {
        fetchRC = nil
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            self.fetchData = reminders
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard type == .insert, let newIndexPath = newIndexPath  else {return}
        collectionView.insertItems(at: [newIndexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch fetchRC != nil {
        case true: return fetchRC?.sections?.count ?? 0
        case false: return fetchData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        switch fetchRC != nil {
        case true:
            guard let id = fetchRC?.object(at: indexPath).identifiers else {return UICollectionViewCell()}
            guard let reminder = eventStore.calendarItem(withIdentifier: id) as? EKReminder else {return UICollectionViewCell()}
            cell.configure(reminder)
        case false:
            guard let reminder = fetchData?[indexPath.row] else {return UICollectionViewCell()}
            cell.configure(reminder)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch fetchRC != nil {
        case true:
            guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
            guard let reminder = eventStore.calendarItem(withIdentifier: id) as? EKReminder else {return}
            edit(reminder)
        case false:
            guard let reminder = fetchData?[indexPath.row] else {return}
            edit(reminder)
        }
    }
    
    func edit(_ reminder: EKReminder) {
        let date = reminder.alarms?.first?.absoluteDate ?? Date()
        eventAlert(date, reminder.title) {
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = $0
            reminder.addAlarm(EKAlarm(absoluteDate: date))
            reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
            do {
                try self.eventStore.save(reminder, commit: true)
                self.eventResult(alert: "미리알림 등록 성공")
            } catch {
                self.eventResult(alert: "미리알림 등록 실패")
            }
        }
    }
    
    private func eventAlert(_ target: Date, _ title: String, saveHandler: @escaping ((String) -> ())) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. d. aa h:mm"
        let alert = UIAlertController(title: "미리알림 등록", message: formatter.string(from: target), preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.clearButtonMode = .always
            textField.text = title
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let saveAction = UIAlertAction(title: "등록", style: .default) { _ in
            let finalTitle = alert.textFields?.first?.text ?? title
            saveHandler(finalTitle)
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        viewController.present(alert, animated: true)
    }
    
    private func eventResult(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirmAction)
        viewController.present(alert, animated: true)
    }
    
}

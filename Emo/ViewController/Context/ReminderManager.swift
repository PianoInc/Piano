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
    private var fetchRC: NSFetchedResultsController<Reminder>?
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.fetchLimit = 20
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Reminder")
        fetchRC?.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard type == .insert, let newIndexPath = newIndexPath  else {return}
        collectionView.insertItems(at: [newIndexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchRC?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let id = fetchRC?.object(at: indexPath).identifiers else {return UICollectionViewCell()}
        guard let reminder = EKEventStore().calendarItem(withIdentifier: id) as? EKReminder else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.configure(reminder)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
        let eventStore = EKEventStore()
        guard let reminder = eventStore.calendarItem(withIdentifier: id) as? EKReminder else {return}
        edit(reminder, using: eventStore)
    }
    
    func edit(_ reminder: EKReminder, using store: EKEventStore) {
        let date = reminder.completionDate ?? Date()
        eventAlert(date, reminder.title) {
            let reminder = EKReminder(eventStore: store)
            reminder.title = $0
            reminder.addAlarm(EKAlarm(absoluteDate: date))
            reminder.calendar = store.defaultCalendarForNewReminders()
            do {
                try store.save(reminder, commit: true)
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

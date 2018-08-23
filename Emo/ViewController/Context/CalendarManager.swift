//
//  CalendarManager.swift
//  Piano
//
//  Created by JangDoRi on 2018. 8. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import EventKitUI

class CalendarManager<Cell: CalendarCollectionViewCell>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, EKEventEditViewDelegate {
    
    private weak var viewController: UIViewController!
    private weak var collectionView: UICollectionView!
    
    private let eventStore = EKEventStore()
    private var fetchRC: NSFetchedResultsController<Calendar>?
    private var fetchData: [EKEvent]?
    
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
        let request = NSFetchRequest<Calendar>(entityName: "Calendar")
        request.fetchLimit = 20
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Calendar.identifiers), ascending: true)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Calendar")
        fetchRC?.delegate = self
    }
    
    func fetchAll() {
        fetchRC = nil
        let cal = Foundation.Calendar.current
        guard let startDate = cal.date(byAdding: .month, value: -6, to: Date()) else {return}
        guard let endDate = cal.date(byAdding: .month, value: 6, to: Date()) else {return}
        guard let eventCal = eventStore.defaultCalendarForNewEvents else {return}
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [eventCal])
        fetchData = eventStore.events(matching: predicate)
        collectionView.reloadData()
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
            guard let event = eventStore.event(withIdentifier: id) else {return UICollectionViewCell()}
            cell.configure(event)
        case false:
            guard let event = fetchData?[indexPath.row] else {return UICollectionViewCell()}
            cell.configure(event)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch fetchRC != nil {
        case true:
            guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
            guard let event = eventStore.event(withIdentifier: id) else {return}
            edit(event)
        case false:
            guard let event = fetchData?[indexPath.row] else {return}
            edit(event)
        }
    }
    
    func edit(_ event: EKEvent) {
        let eventController = EKEventEditViewController()
        eventController.eventStore = eventStore
        eventController.event = event
        eventController.editViewDelegate = self
        viewController.present(eventController, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        guard action == .canceled else {return}
        controller.dismiss(animated: true)
    }
    
}

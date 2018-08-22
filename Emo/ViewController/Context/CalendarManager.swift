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
    private var fetchRC: NSFetchedResultsController<Calendar>?
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        let request = NSFetchRequest<Calendar>(entityName: "Calendar")
        request.fetchLimit = 20
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Calendar")
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
        guard let event = EKEventStore().event(withIdentifier: id) else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.configure(event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
        let eventStore = EKEventStore()
        guard let event = eventStore.event(withIdentifier: id) else {return}
        edit(event, using: eventStore)
    }
    
    func edit(_ event: EKEvent, using store: EKEventStore) {
        let eventController = EKEventEditViewController()
        eventController.eventStore = store
        eventController.event = event
        eventController.editViewDelegate = self
        viewController.present(eventController, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        guard action == .canceled else {return}
        controller.dismiss(animated: true)
    }
    
}

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

class CalendarManager<Section: CalendarCollectionReusableView, Cell: CalendarCollectionViewCell>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private weak var viewController: UIViewController!
    private weak var collectionView: UICollectionView!
    
    private let eventStore = EKEventStore()
    private lazy var request: NSFetchRequest<Calendar> = {
        let request: NSFetchRequest<Calendar> = Calendar.fetchRequest()
        request.fetchLimit = 20
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Calendar.identifiers), ascending: true)]
        return request
    }()
    private var fetchRC: NSFetchedResultsController<Calendar>?
    private var fetchData = [[String : [EKEvent]]]()
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        fetchData.removeAll()
        collectionView.reloadData()
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
        let events = eventStore.events(matching: predicate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        for event in events {
            let sectionTitle = dateFormatter.string(from: event.startDate)
            print(sectionTitle)
            if let sectionIndex = fetchData.index(where: {$0.keys.first == sectionTitle}) {
                fetchData[sectionIndex][sectionTitle]?.append(event)
            } else {
                fetchData.append([sectionTitle : [event]])
            }
        }
        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard type == .insert, let newIndexPath = newIndexPath  else {return}
        collectionView.insertItems(at: [newIndexPath])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch fetchRC != nil {
        case true: return 1
        case false: return fetchData.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch fetchRC != nil {
        case true: return fetchRC?.sections?.count ?? 0
        case false: return fetchData[section].values.first?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Section.reuseIdentifier, for: indexPath) as! CalendarCollectionReusableView
        guard let title = fetchData[indexPath.section].keys.first else {return UICollectionReusableView()}
        section.configure(title)
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        switch fetchRC != nil {
        case true:
            guard let id = fetchRC?.object(at: indexPath).identifiers else {return UICollectionViewCell()}
            guard let event = eventStore.event(withIdentifier: id) else {return UICollectionViewCell()}
            cell.configure(event)
        case false:
            guard let event = fetchData[indexPath.section].values.first?[indexPath.item] else {return UICollectionViewCell()}
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
            guard let event = fetchData[indexPath.section].values.first?[indexPath.item] else {return}
            edit(event)
        }
    }
    
    func edit(_ event: EKEvent) {
        let eventVC = EKEventViewController()
        eventVC.allowsEditing = true
        eventVC.event = event
        viewController.navigationController?.view.backgroundColor = UIColor(hex6: "F9F9F9")
        viewController.navigationController?.pushViewController(eventVC, animated: true)
    }
    
}

extension CalendarManager {
    func refreshFetchRequest(with text: String) {
        
    }
}

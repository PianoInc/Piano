//
//  BlockTableViewController.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 14..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class MainCollectionViewController: UIViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var titleView: TitleView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: BottomView!
    weak var persistentContainer: NSPersistentContainer!

    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var noteFetchRequest: NSFetchRequest<Note> = {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "modifiedDate", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }()

    lazy var noteResultsController: NSFetchedResultsController<Note> = {
        let controller = NSFetchedResultsController(fetchRequest: noteFetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()

    var resultsController: NSFetchedResultsController<Note>?
    var calendarDataSource: [String]?
    var reminderDataSource: [String]?
    var contactDataSource: [String]?
    var photoDataSource: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.delegate = self
        resultsController = createNoteResultsController()
        setupCollectionViewLayout(for: .note)

    }

}

extension MainCollectionViewController {
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

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
    
    var resultsController: NSFetchedResultsController<Note>?
    var contactManager: ContactManager<ContactCollectionViewCell>?
    var reminderManager: ReminderManager<ReminderCollectionViewCell>?
    var calendarManager: CalendarManager<CalendarCollectionViewCell>?
    var photoManager: PhotoManager<PhotoCollectionViewCell>?
    
    lazy var noteFetchRequest: NSFetchRequest<Note> = {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "modifiedDate", ascending: true)
        request.fetchLimit = 20
        request.sortDescriptors = [sort]
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNote()
        bottomView.delegate = self
        bottomView.returnToNoteList = {
            self.setup(for: .note)
            self.loadNote()
        }
    }
    
    private func loadNote() {
        resultsController = createNoteResultsController()
        setupCollectionViewLayout(for: .note)
        refreshCollectionView()
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
    
    func refreshCollectionView() {
        do {
            try resultsController?.performFetch()
            let count = resultsController?.fetchedObjects?.count ?? 0
            titleView.label.text = (count <= 0) ? "메모없음" : "\(count)개의 메모"
            navigationItem.titleView = titleView
            collectionView.reloadData()
        } catch {
            // TODO: 예외처리
        }
    }
}

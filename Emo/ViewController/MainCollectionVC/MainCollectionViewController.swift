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

    internal var typingCounter = 0
    internal var searchRequestDelay = 0.1

    lazy var noteFetchRequest: NSFetchRequest<Note> = {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "modifiedDate", ascending: false)
        request.fetchLimit = 100
        request.sortDescriptors = [sort]
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchRequestDelay()
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

            collectionView.performBatchUpdates({
                collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        } catch {
            // TODO: 예외처리
        }
    }

    /// appDelegate applicationWillResignActive 에서 저장한 노트수에 따라서
    /// 검색 요청 지연 시간을 설정하는 메서드
    private func setSearchRequestDelay() {
        let noteCount = UserDefaults.standard.integer(forKey: "NoteCount")
        switch noteCount {
        case 0..<500:
            searchRequestDelay = 0.1
        case 500...1000:
            searchRequestDelay = 0.2
        default:
            searchRequestDelay = 0.3
        }
    }

    // for test
    private func setupDummyNotes() {
        if resultsController?.fetchedObjects?.count ?? 0 < 100 {
            for _ in 1...50000 {
                let note = Note(context: managedContext)
                note.content = "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean lacinia bibendum nulla sed consectetur. Nullam id dolor id nibh ultricies vehicula ut id elit. Donec sed odio dui. Nullam quis risus eget urna mollis ornare vel eu leo."
            }
            for _ in 1...5 {
                let note = Note(context: managedContext)
                note.content = "👻 apple Nullam id dolor id nibh ultricies vehicula ut id elit."
            }

            for _ in 1...5 {
                let note = Note(context: managedContext)
                note.content = "👻 bang Maecenas faucibus mollis interdum."
            }

            saveContext()
            try? resultsController?.performFetch()
        }
    }
}

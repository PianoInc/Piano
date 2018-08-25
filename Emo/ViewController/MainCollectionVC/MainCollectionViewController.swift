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
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var editBarButton: UIBarButtonItem!
    
    
    weak var persistentContainer: NSPersistentContainer!

    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
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
        bottomView.mainViewController = self
        bottomView.returnToNoteList = {
            self.setup(typingState: .note)
            self.loadNote()
        }
    }

    private func loadNote() {
        resultsController = createNoteResultsController()
        setupCollectionViewLayout(for: .note)
        refreshCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoDetailViewController" {
            guard let photoDetailVC = segue.destination as? PhotoDetailViewController else {return}
            guard let image = sender as? UIImage else {return}
            photoDetailVC.image = image
        }
    }
}

extension MainCollectionViewController {
    
    func refreshCollectionView() {
        if resultsController?.managedObjectContext != backgroundContext {
            resultsController = NSFetchedResultsController(
                fetchRequest: noteFetchRequest,
                managedObjectContext: backgroundContext,
                sectionNameKeyPath: nil,
                cacheName: "Note"
            )
        }

        do {
            try resultsController?.performFetch()
            let count = resultsController?.fetchedObjects?.count ?? 0
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.titleView.label.text = (count <= 0) ? "메모없음" : "\(count)개의 메모"
                self.navigationItem.titleView = self.titleView

                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }, completion: nil)
            }
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
        case 500..<1000:
            searchRequestDelay = 0.2
        case 1000..<5000:
            searchRequestDelay = 0.3
        case 5000..<10000:
            searchRequestDelay = 0.4
        default:
            searchRequestDelay = 0.5
        }
    }

    // for test
    private func setupDummyNotes() {
        if resultsController?.fetchedObjects?.count ?? 0 < 100 {
            for _ in 1...50000 {
                let note = Note(context: mainContext)
                note.content = "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean lacinia bibendum nulla sed consectetur. Nullam id dolor id nibh ultricies vehicula ut id elit. Donec sed odio dui. Nullam quis risus eget urna mollis ornare vel eu leo."
            }
            for _ in 1...5 {
                let note = Note(context: mainContext)
                note.content = "👻 apple Nullam id dolor id nibh ultricies vehicula ut id elit."
            }

            for _ in 1...5 {
                let note = Note(context: mainContext)
                note.content = "👻 bang Maecenas faucibus mollis interdum."
            }

            saveContext()
            try? resultsController?.performFetch()
        }
    }
    
    private func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//
//  ContactManager.swift
//  Piano
//
//  Created by JangDoRi on 2018. 8. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI

enum ContactEditType {
    case add, modify
}

class ContactManager<Cell: ContactCollectionViewCell>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CNContactViewControllerDelegate {
    
    private weak var viewController: UIViewController!
    private weak var collectionView: UICollectionView!
    private var fetchRC: NSFetchedResultsController<Contact>?
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        request.fetchLimit = 20
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Contact")
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
        guard let contact = try? CNContactStore().unifiedContact(withIdentifier: id, keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor]) else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.configure(contact)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
        let contactStore = CNContactStore()
        guard let contact = try? contactStore.unifiedContact(withIdentifier: id, keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor]) else {return}
        edit(contact, using: contactStore, for: .modify)
    }
    
    func edit(_ contact: CNContact, using store: CNContactStore, for type: ContactEditType) {
        var contactVC: CNContactViewController!
        switch type {
        case .add: contactVC = CNContactViewController(forNewContact: contact)
        case .modify: contactVC = CNContactViewController(for: contact)
        }
        contactVC.contactStore = store
        contactVC.delegate = self
        contactVC.allowsActions = false
        viewController.present(contactVC, animated: true)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard contact == nil else {return}
        viewController.dismiss(animated: true)
    }
    
}

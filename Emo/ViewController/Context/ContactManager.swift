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

let CNContactKeysToFetch: [CNKeyDescriptor] = [CNContactGivenNameKey, CNContactFamilyNameKey,
                                               CNContactPhoneNumbersKey, CNContactEmailAddressesKey,
                                               CNContactUrlAddressesKey] as [CNKeyDescriptor]

enum ContactEditType {
    case add, modify
}

class ContactManager<Cell: ContactCollectionViewCell>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CNContactViewControllerDelegate {
    
    private weak var viewController: UIViewController!
    private weak var collectionView: UICollectionView!
    
    private let contactStore = CNContactStore()
    private var fetchRC: NSFetchedResultsController<Contact>?
    private var fetchData: [CNContact]?
    
    init(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        fetchData = nil
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        request.fetchLimit = 20
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Contact")
        fetchRC?.delegate = self
    }
    
    func fetchAll() {
        fetchRC = nil
        fetchData = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: CNContactKeysToFetch)
        try? contactStore.enumerateContacts(with: request) { contact, error in
            self.fetchData?.append(contact)
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
            guard let contact = try? contactStore.unifiedContact(withIdentifier: id, keysToFetch: CNContactKeysToFetch) else {return UICollectionViewCell()}
            cell.configure(contact)
        case false:
            guard let contact = fetchData?[indexPath.row] else {return UICollectionViewCell()}
            cell.configure(contact)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch fetchRC != nil {
        case true:
            guard let id = fetchRC?.object(at: indexPath).identifiers else {return}
            guard let contact = try? contactStore.unifiedContact(withIdentifier: id, keysToFetch: CNContactKeysToFetch) else {return}
            edit(contact, for: .modify)
        case false:
            guard let contact = fetchData?[indexPath.row] else {return}
            edit(contact, for: .modify)
        }
    }
    
    func edit(_ contact: CNContact, for type: ContactEditType) {
        var contactVC: CNContactViewController!
        switch type {
        case .add: contactVC = CNContactViewController(forNewContact: contact)
        case .modify: contactVC = CNContactViewController(for: contact)
        }
        contactVC.contactStore = contactStore
        contactVC.delegate = self
        contactVC.allowsActions = false
        viewController.present(contactVC, animated: true)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard contact == nil else {return}
        viewController.dismiss(animated: true)
    }
    
}

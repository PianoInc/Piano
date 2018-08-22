//
//  ContactCollectionViewCell.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import Contacts

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var numberStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var urlStackView: UIStackView!
    
    func configure(_ contact: CNContact) {
        nameLabel.text = contact.givenName + contact.familyName
        numberLabel.text = contact.phoneNumbers.first(where: {$0.value.stringValue != ""})?.value.stringValue.replacingOccurrences(of: "//", with: "")
        emailLabel.text = contact.emailAddresses.first(where: {$0.value != ""})?.value as String?
        urlLabel.text = contact.urlAddresses.first(where: {$0.value != ""})?.value as String?
    }
    
}

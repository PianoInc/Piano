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
    
    func configure(_ contact: CNContact) {
        //TODO: firstName, nameName에 대한 결합 순서는 국가마다 다르게 하기 -> NSLinguisticTagger로 해당 string의 국가를 파악 후에 처리하기. 이를테면 미국은 아래의 순서, 한국은 반대의 순서
        nameLabel.text = contact.givenName + contact.familyName
    }
    
}

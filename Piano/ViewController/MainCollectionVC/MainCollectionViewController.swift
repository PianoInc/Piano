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
    enum VCType {
        case note
        case calendar
        case reminder
        case contact
        case photos
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: BottomView!

    weak var persistentContainer: NSPersistentContainer!


    internal var type: VCType = .note {
        didSet {
            // 컬렉션 뷰를 타입에 맞게 리로드(컬렉션 뷰의 데이터소스 로직에서 타입이 노트일 경우 item count == 0)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
    }

}

//
//  MainTableVC_Action.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension MainCollectionViewController {
    
    @IBAction func tapCalendar(_ sender: Any) {
        //1. 테이블 뷰 일정으로 갱신
        reloadCollectionView(for: .calendar)
        
        //2. 키보드 원래대로 만들기
    }
    
    @IBAction func tapReminder(_ sender: Any) {
        
    }
    
    @IBAction func tapContact(_ sender: Any) {
        
    }
    
    @IBAction func tapPhotos(_ sender: Any) {
        
    }
}

extension MainCollectionViewController {
    enum CollectionViewType {
        case note
        case calendar
        case reminder
        case contact
        case photos
    }
    
    private func reloadCollectionView(for: CollectionViewType) {
        //1. FetchedResultsController 갱신
        
        //2. 비동기로 리로드
    }
}

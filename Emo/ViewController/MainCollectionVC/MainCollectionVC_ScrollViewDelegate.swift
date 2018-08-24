//
//  MainCollectionVC_ScrollViewDelegate.swift
//  Emo
//
//  Created by hoemoon on 23/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

extension MainCollectionViewController: UIScrollViewDelegate {
    // 현재 컬렉션뷰의 셀 갯수가 (fetchLimit / 0.9) 보다 큰 경우,
    // 맨 밑까지 스크롤하면 fetchLimit을 증가시킵니다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0,
            scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {

            if collectionView.numberOfItems(inSection: 0) > 90 {
                noteFetchRequest.fetchLimit += 50
                try? resultsController?.performFetch()
                collectionView.reloadData()
            }
        }
    }
}

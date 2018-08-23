//
//  MainCollectionVC_ScrollViewDelegate.swift
//  Emo
//
//  Created by hoemoon on 23/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

extension MainCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) * 0.9 {
            noteFetchRequest.fetchLimit += 50
            try? resultsController?.performFetch()
            collectionView.reloadData()
        }
    }
}

//
//  MainCollectionVC_CollectionViewDelegateFlowLayout.swift
//  Emo
//
//  Created by JangDoRi on 2018. 8. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
extension MainCollectionViewController: CollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
}

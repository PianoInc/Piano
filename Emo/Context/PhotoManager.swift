//
//  PhotoManager.swift
//  Piano
//
//  Created by JangDoRi on 2018. 8. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import Photos

let PHImageManagerMinimumSize: CGFloat = 125

class PhotoManager<Cell: PhotoCollectionViewCell>: NSObject, PHPhotoLibraryChangeObserver, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private weak var collectionView: UICollectionView!
    
    private let imageManager = PHCachingImageManager()
    private var photoFetchResult = PHFetchResult<PHAsset>()
    private var photoAssets = [PHAsset]()
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 2
            flowLayout.minimumLineSpacing = 2
        }
    }
    
    func fetchAll() {
        guard let album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject else {return}
        PHPhotoLibrary.shared().register(self)
        photoFetchResult = PHAsset.fetchAssets(in: album, options: nil)
        photoAssets = photoFetchResult.objects(at: IndexSet(0...photoFetchResult.count - 1)).reversed()
        collectionView.reloadData()
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let newPhotos = changeInstance.changeDetails(for: photoFetchResult) else {return}
        photoFetchResult = newPhotos.fetchResultAfterChanges
        photoAssets = photoFetchResult.objects(at: IndexSet(0...photoFetchResult.count - 1)).reversed()
        DispatchQueue.main.async {
            if newPhotos.hasIncrementalChanges {
                self.collectionView.performBatchUpdates({
                    if let removed = newPhotos.removedIndexes, !removed.isEmpty {
                        self.collectionView.deleteItems(at: removed.map({IndexPath(item: $0, section: 0)}))
                    }
                    if let inserted = newPhotos.insertedIndexes, !inserted.isEmpty {
                        self.collectionView.insertItems(at: inserted.map({IndexPath(item: $0, section: 0)}))
                    }
                    if let changed = newPhotos.changedIndexes, !changed.isEmpty {
                        self.collectionView.reloadItems(at: changed.map({IndexPath(item: $0, section: 0)}))
                    }
                    newPhotos.enumerateMoves { from, to in
                        self.collectionView.moveItem(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
                    }
                })
            } else {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
        
        var portCellNum: CGFloat = 3
        var landCellNum: CGFloat = 5
        if UIDevice.current.userInterfaceIdiom == .pad {
            portCellNum = portCellNum * 2
            landCellNum = landCellNum * 2
        }
        
        let portCutSpacing = flowLayout.minimumInteritemSpacing * (portCellNum - 1)
        let landCutSpacing = flowLayout.minimumInteritemSpacing * (landCellNum - 1)
        
        var cellSize = collectionView.bounds.height
        if flowLayout.scrollDirection == .vertical {
            cellSize = floor((collectionView.bounds.width - portCutSpacing) / portCellNum)
            if UIApplication.shared.statusBarOrientation.isLandscape {
                cellSize = floor((collectionView.bounds.width - landCutSpacing) / landCellNum)
            }
        }
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        let photo = photoAssets[indexPath.row]
        let size = CGSize(width: PHImageManagerMinimumSize, height: PHImageManagerMinimumSize)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(for: photo, targetSize: size, contentMode: .aspectFit, options: options) { (image, _) in
            cell.configure(image)
        }
        return cell
    }
    
}

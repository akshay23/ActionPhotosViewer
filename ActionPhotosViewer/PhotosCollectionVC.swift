//
//  PhotosCollectionVC.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotosCollectionVC: UICollectionViewController {
    
    var numberOfPhotosToShow: Int!
    var currentPhotoFetch : PHFetchResult<PHAssetCollection>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Get user library collection
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        fetchOption.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        currentPhotoFetch = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                       subtype: .smartAlbumUserLibrary,
                                                                       options: fetchOption)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UICollectionViewDataSource
extension PhotosCollectionVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotosToShow
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
}

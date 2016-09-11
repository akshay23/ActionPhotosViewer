//
//  SlideshowVC.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Photos

class SlideshowVC: UIViewController {

    @IBOutlet var slideshowImageView: UIImageView!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    var numberOfPhotosToShow: Int!
    var currentPhotoFetch : PHFetchResult<PHAssetCollection>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI stuff
        stopButton.layer.borderWidth = 1.0
        stopButton.layer.cornerRadius = 2.0
        stopButton.layer.borderColor = UIColor.blue.cgColor
        
        restartButton.layer.borderWidth = 1.0
        restartButton.layer.cornerRadius = 2.0
        restartButton.layer.borderColor = UIColor.blue.cgColor
        
        slideshowImageView.layer.shadowOpacity = 0.5
        slideshowImageView.layer.shadowRadius = 5
        slideshowImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        let navTitle: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: (navigationController?.navigationBar.frame.height)!))
        navTitle.text = "Slideshow Viewer"
        navTitle.textColor = UIColor.purple
        navTitle.backgroundColor = UIColor.clear
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 17)
        navigationItem.titleView = navTitle

        // Get user library collection
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        fetchOption.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        currentPhotoFetch = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                    subtype: .smartAlbumUserLibrary,
                                                                    options: fetchOption)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  SlideshowVC.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Photos
import Intents
import Foundation

class SlideshowVC: UIViewController {

    @IBOutlet var slideshowImageView: UIImageView!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var stylePicker: UIPickerView!
    @IBOutlet var intentLabel: UILabel!
    
    var numberOfPhotosToShow: Int = 10
    var currentShowIndex: Int!
    var images = [UIImage]()
    var showTimer: Timer!
    var styles: [String] = ["None","RubyRed","BigBlue","GoGreen"]
    var slideshowIntent: INStartPhotoPlaybackIntent?
    var filteredAssets = [PHAsset]()
    var fetchResult: PHFetchResult<PHAsset>?

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
        
        stylePicker.dataSource = self
        stylePicker.delegate = self
        stylePicker.showsSelectionIndicator = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setup the text in the label
        if let _ = slideshowIntent {
            intentLabel.text = "INStartPhotoPlaybackIntent"
        } else {
            intentLabel.text = "No Intent"
        }

        // Setup asset fetch
        setupAssets()
        
        // Fetch 'em
        fetchAssets()
        
        // Start timer if we have images
        if images.count > 0 {
            stopButton.isEnabled = true
            restartButton.isEnabled = true
            currentShowIndex = 0
            resetTimer()
            print("Slideshow timer started")
        } else {
            print("Nothing to show!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAssets() {
        // Sort images by creation date, descending
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        
        // Date range from intent
        if let creationDate = slideshowIntent?.dateCreated, let startDate = creationDate.startDateComponents?.date, let endDate = creationDate.endDateComponents?.date {
            options.predicate = NSPredicate.init(format: "creationDate >= %@ AND creationDate <= %@", startDate as NSDate, endDate as NSDate)
        }
        
        if let intent = slideshowIntent, let albumName = intent.albumName {
            // Album fetch (if any)
            let albumFetchOptions = PHFetchOptions()
            albumFetchOptions.predicate = NSPredicate.init(format: "title = %@", albumName)
            
            let albumCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: albumFetchOptions)
            if (albumCollection.count > 0) {
                fetchResult = PHAsset.fetchAssets(in: albumCollection.firstObject!, options: options)
            }
        } else {
            // Fetch all the assets
            fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
        }
        
        // Filter out images that are from given location
        if let fetchResult = self.fetchResult, let intent = slideshowIntent, let location = intent.locationCreated {
            fetchResult.enumerateObjects({
                (asset, index, complete) in
                
                let distanceThreshold: CLLocationDistance = 10000.0;  // meters
                if let pLocation = asset.location, let iLocation = location.location {
                    if (pLocation.distance(from: iLocation) <= distanceThreshold) {
                        self.filteredAssets.append(asset)
                    }
                }
            })
        }
    }
    
    func fetchAssets() {
        if let fetchResult = self.fetchResult {
            if (self.filteredAssets.count > 0) {
                for index in 0...numberOfPhotosToShow-1 {
                    if (index > self.filteredAssets.count - 1) {
                        return
                    }
                    let asset = self.filteredAssets[index]
                    requestAnImage(asset: asset)
                }
            } else if (fetchResult.count > 0) {
                for index in 0...numberOfPhotosToShow-1 {
                    if (index > fetchResult.count - 1) {
                        return
                    }
                    let asset = fetchResult.object(at: index)
                    requestAnImage(asset: asset)
                }
            }
        }
    }
    
    func requestAnImage(asset: PHAsset) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        let imgManager = PHImageManager.default()
        imgManager.requestImage(for: asset,
                                targetSize: slideshowImageView.frame.size,
                                contentMode: PHImageContentMode.aspectFill,
                                options: requestOptions) {
                                    (image, _) in
                                    
                                    // Add the returned image to your array
                                    if let image = image {
                                        self.images.append(image)
                                    }
        }
        
    }
    
    func resetTimer() {
        showTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(SlideshowVC.showNextPhoto),
                                         userInfo: nil,
                                         repeats: true)
    }

    func showNextPhoto() {
        slideshowImageView.image = images[currentShowIndex]
        currentShowIndex! += 1
        
        if (currentShowIndex >= images.count) {
            currentShowIndex = 0
        }
    }
}

// MARK: IBActions
extension SlideshowVC {
    @IBAction func restartShow(_ sender: AnyObject) {
        showTimer.invalidate()
        currentShowIndex = 0
        stopButton.isEnabled = true
        resetTimer()
    }
    
    @IBAction func stopShow(_ sender: AnyObject) {
        showTimer.invalidate()
        stopButton.isEnabled = false
    }
}

// MARK: UIPickerViewDataSource
extension SlideshowVC: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return styles.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: UIPickerViewDelegate
extension SlideshowVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return styles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch styles[row] {
        case "None":
            slideshowImageView.tintColor = nil
            break
        case "RubyRed":
            slideshowImageView.tintColor = UIColor.red
            break
        default:
            break;
        }
    }
}

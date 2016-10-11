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
    
    var numberOfPhotosToShow: Int!
    var currentShowIndex: Int!
    var images = [UIImage]()
    var showTimer: Timer!
    var styles: [String] = ["None","RubyRed","BigBlue","GoGreen"]
    var slideshowIntent: INStartPhotoPlaybackIntent?
    var filteredAssets = [PHAsset]()
    var fetchResult: PHFetchResult<PHAsset>?
    
    let imgManager = PHImageManager.default()

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
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        images = []
        currentShowIndex = 0
        intentLabel.text = "No Intent"
        
        if let fetchResult = fetchResult, let intent = slideshowIntent, let location = intent.locationCreated {
            fetchResult.enumerateObjects({
                (asset, index, complete) in
                
                let distanceThreshold: CLLocationDistance = 100000.0;  // meters
                if let pLocation = asset.location, let iLocation = location.location {
                    if (pLocation.distance(from: iLocation) <= distanceThreshold) {
                        self.filteredAssets.append(asset)
                    }
                }
            })
        }

        fetchPhotos()
        
        if images.count > 0 {
            stopButton.isEnabled = true
            restartButton.isEnabled = true
            resetTimer()
            print("Slideshow timer started")
        }
        
        if let intent = slideshowIntent {
            intentLabel.text = intent.identifier
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhotos() {
        if let fetchResult = fetchResult, fetchResult.count > 0 {
            if (self.filteredAssets.count >= numberOfPhotosToShow) {
                for index in 0...numberOfPhotosToShow-1 {
                    let asset = self.filteredAssets[index]
                    requestAnImage(asset: asset)
                }
            } else if (fetchResult.count >= numberOfPhotosToShow) {
                for index in 0...numberOfPhotosToShow-1 {
                    let asset = fetchResult.object(at: index)
                    requestAnImage(asset: asset)
                }
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
        slideshowImageView.image = images[currentShowIndex%numberOfPhotosToShow]
        currentShowIndex! += 1
    }
    
    func requestAnImage(asset: PHAsset) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        imgManager.requestImage(for: asset,
                                targetSize: slideshowImageView.frame.size,
                                contentMode: PHImageContentMode.aspectFill,
                                options: requestOptions)
        {
            (image, _) in
            
            // Add the returned image to your array
            if let image = image {
                self.images.append(image)
            }
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

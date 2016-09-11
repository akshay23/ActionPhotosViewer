//
//  SlideshowVC.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Photos
import Foundation

class SlideshowVC: UIViewController {

    @IBOutlet var slideshowImageView: UIImageView!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var stylePicker: UIPickerView!
    
    var numberOfPhotosToShow: Int!
    var currentShowIndex: Int!
    var images: [UIImage]?
    var showTimer: Timer!
    var styles: [String] = ["None","RubyRed","BigBlue","GoGreen"]

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
        
        images = []
        currentShowIndex = 0
        fetchPhotoAtIndexFromEnd(index: 0)
        
        if let images = images, images.count > 0 {
            stopButton.isEnabled = true
            restartButton.isEnabled = true
            resetTimer()
            print("Slideshow timer started")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhotoAtIndexFromEnd(index: Int) {
        let imgManager = PHImageManager.default()
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            // Perform the image request
            imgManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1 - index) as PHAsset,
                                    targetSize: slideshowImageView.frame.size,
                                    contentMode: PHImageContentMode.aspectFill,
                                    options: requestOptions)
            {
                (image, _) in
                
                // Add the returned image to your array
                if let image = image {
                    self.images!.append(image)
                }
                
                // If you haven't already reached the first
                // index of the fetch result and if you haven't
                // already stored all of the images you need,
                // perform the fetch request again with an
                // incremented index
                if index + 1 < fetchResult.count && self.images!.count < self.numberOfPhotosToShow {
                    self.fetchPhotoAtIndexFromEnd(index: index + 1)
                } else {
                    // Else you have completed creating your array
                    print("Completed array: \(self.images)")
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
        slideshowImageView.image = images![currentShowIndex%numberOfPhotosToShow]
        currentShowIndex! += 1
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



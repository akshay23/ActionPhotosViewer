//
//  MainViewController.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {

    @IBOutlet var viewPhotosButton: UIButton!
    @IBOutlet var numberOfPhotosTxtField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPhotosTxtField.layer.borderWidth = 1.0
        numberOfPhotosTxtField.addTarget(self, action: #selector(MainViewController.checkTextField), for: .editingChanged)
        numberOfPhotosTxtField.layer.borderColor = UIColor.blue.cgColor
        
        viewPhotosButton.layer.borderWidth = 1.0
        viewPhotosButton.layer.borderColor = UIColor.blue.cgColor
        
        let viewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.hideKeyboard))
        view.addGestureRecognizer(viewTap)
        
        let navTitle: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: (navigationController?.navigationBar.frame.height)!))
        navTitle.text = "Welcome to ActionPhotosViewer"
        navTitle.textColor = UIColor.purple
        navTitle.backgroundColor = UIColor.clear
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 17)
        navigationItem.titleView = navTitle
        
        if (PHPhotoLibrary.authorizationStatus() != .authorized) {
            PHPhotoLibrary.requestAuthorization() {
                status in
                print("User's photo auth status is \(status.rawValue)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show photos" && segue.destination is PhotosCollectionVC {
            let photosVC = segue.destination as! PhotosCollectionVC
            photosVC.numberOfPhotosToShow = Int(numberOfPhotosTxtField.text!)
        }
    }

    func hideKeyboard() {
        if (numberOfPhotosTxtField.isFirstResponder) {
            numberOfPhotosTxtField.resignFirstResponder()
        }
    }
    
    func checkTextField() {
        if let text = numberOfPhotosTxtField.text,!text.isEmpty {
            viewPhotosButton.isEnabled = true
        } else {
            viewPhotosButton.isEnabled = false
        }
    }
}

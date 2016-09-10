//
//  MainViewController.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var viewPhotosButton: UIButton!
    @IBOutlet var numberOfPhotosTxtField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPhotosTxtField.layer.borderWidth = 1.0
        numberOfPhotosTxtField.layer.borderColor = UIColor.blue.cgColor
        
        viewPhotosButton.layer.borderWidth = 1.0
        viewPhotosButton.layer.borderColor = UIColor.blue.cgColor
        
        let viewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.hideKeyboard))
        view.addGestureRecognizer(viewTap)
        
        let navTitle: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: (navigationController?.navigationBar.frame.height)!))
        navTitle.text = "Welcome to ActionPhotoViewer"
        navTitle.textColor = UIColor.purple
        navTitle.backgroundColor = UIColor.clear
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 17)
        
        navigationItem.titleView = navTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func hideKeyboard() {
        if (numberOfPhotosTxtField.isFirstResponder) {
            numberOfPhotosTxtField.resignFirstResponder()
        }
    }
}

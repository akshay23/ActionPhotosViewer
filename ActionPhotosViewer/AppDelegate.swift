//
//  AppDelegate.swift
//  ActionPhotosViewer
//
//  Created by Akshay Bharath on 9/10/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import UIKit
import Intents
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (PHPhotoLibrary.authorizationStatus() != .authorized) {
            PHPhotoLibrary.requestAuthorization() {
                status in
                print("User's photo auth status is \(status.rawValue)")
            }
        }
        
        if (INPreferences.siriAuthorizationStatus() != .authorized) {
            INPreferences.requestSiriAuthorization() {
                status in
                print("Siri auth is \(status.rawValue)")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        // Get storyboard
        if let window = self.window, let rootVC = window.rootViewController as? UINavigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let interaction = userActivity.interaction, let intent = interaction.intent as? INStartPhotoPlaybackIntent {
                print("INTENT is \(userActivity.activityType)")
                
                if let albumName = intent.albumName {
                    print("Album name is \(albumName)")
                }
                
                if let searchLocation = intent.locationCreated {
                    print("Search location is \(searchLocation)")
                }
                
                if let creationDate = intent.dateCreated, let startDate = creationDate.startDateComponents?.date, let endDate = creationDate.endDateComponents?.date {
                    print("Created start date is \(startDate)")
                    print("Created end date is \(endDate)")
                }

                let slideshowVC = storyboard.instantiateViewController(withIdentifier: "slideshowVC") as! SlideshowVC
                slideshowVC.numberOfPhotosToShow = 10
                slideshowVC.slideshowIntent = intent
                rootVC.pushViewController(slideshowVC, animated: true)
            } else {
                print("NO INTENT")
            }
        }

    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


//
//  IntentHandler.swift
//  SiriExtension
//
//  Created by Akshay Bharath on 9/11/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import Intents
import Photos

class IntentHandler: INExtension, INStartPhotoPlaybackIntentHandling {

    // Optional method
    // This is where we can do further checks/validation on the dates provided by the user (if provided)
    func resolveDateCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
                            with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {
        if let dateCreated = intent.dateCreated {
            completion(INDateComponentsRangeResolutionResult.success(with: dateCreated))
        } else {
            completion(INDateComponentsRangeResolutionResult.notRequired())
        }
    }

    // Optional method
    // Further validation/checks on the album name provided (if any)
    func resolveAlbumName(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
                          with completion: @escaping (INStringResolutionResult) -> Void) {
        if let album = intent.albumName {
            let userAlbumsOptions = PHFetchOptions()
            userAlbumsOptions.predicate = NSPredicate.init(format: "estimatedAssetCount > 0")
            
            let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: userAlbumsOptions)
            userAlbums.enumerateObjects({
                (collection, index, stop) in
                
                if let albumName = collection.localizedTitle {
                    if (album == albumName) {
                        completion(INStringResolutionResult.success(with: albumName))
                        return
                    }
                }
            })
            
            // Could not find album
            completion(INStringResolutionResult.unsupported())
        } else {
            completion(INStringResolutionResult.notRequired())
        }
    }

    // Optional method
    // Validate people info if app unerstands people
    func resolvePeopleInPhoto(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
                              with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        completion([INPersonResolutionResult.notRequired()])
    }

    // Optional method
    // Further validation/checks on location info provided by user (if any)
    func resolveLocationCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
                                with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if let location = intent.locationCreated {
            completion(INPlacemarkResolutionResult.success(with: location))
        } else {
            completion(INPlacemarkResolutionResult.notRequired())
        }
    }

    // Optional method
    // Can do other types of validation here (maybe app-specific validations)
    func confirm(startPhotoPlayback intent: INStartPhotoPlaybackIntent,
                 completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        let response = INStartPhotoPlaybackIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }

    // Required method
    // We can pass additional information here and the actually handle user intent
    func handle(startPhotoPlayback intent: INStartPhotoPlaybackIntent,
                completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        activity.addUserInfoEntries(from: ["Greeting": "Watup"])

        let response = INStartPhotoPlaybackIntentResponse(code: .continueInApp, userActivity: activity)
        completion(response)
    }
}

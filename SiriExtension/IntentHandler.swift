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
    func resolveDateCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent, with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {
        if let creationDate = intent.dateCreated {
            // We have date information
            completion(INDateComponentsRangeResolutionResult.success(with: creationDate))
        } else {
            // Not required
            completion(INDateComponentsRangeResolutionResult.notRequired())
        }
    }

    // Optional method
    // Further validation/checks on the album name provided (if any)
    func resolveAlbumName(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        // Not required, but lets check if album exists if given
        if let album = intent.albumName {
            let userAlbumsOptions = PHFetchOptions()
            userAlbumsOptions.predicate = NSPredicate.init(format: "estimatedAssetCount > 0 AND title = %@", album)
            
            let albumCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: userAlbumsOptions)
            if (albumCollection.count > 0) {
                // Found album
                completion(INStringResolutionResult.success(with: album))
            } else {
                // Could not find album
                completion(INStringResolutionResult.unsupported())
            }
        } else {
            completion(INStringResolutionResult.notRequired())
        }
    }

    // Optional method
    // Validate people info if app unerstands people
    func resolvePeopleInPhoto(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        if let peeps = intent.peopleInPhoto, peeps.count > 0 {
            // We have people info
            var personResolutions = [INPersonResolutionResult]()
            for person in peeps {
                personResolutions.append(INPersonResolutionResult.success(with: person))
            }
            completion(personResolutions)
        } else {
            // Not required
            completion([INPersonResolutionResult.notRequired()])
        }
    }

    // Optional method
    // Further validation/checks on location info provided by user (if any)
    func resolveLocationCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if let location = intent.locationCreated {
            // We have location information
            completion(INPlacemarkResolutionResult.success(with: location))
        } else {
            // Not required
            completion(INPlacemarkResolutionResult.notRequired())
        }
    }

    // Optional method
    // Can do other types of validation here
    // such as: (intent.albumName == nil) && (intent.locationCreated == nil) && (intent.dateCreated == nil)
    // or check if user is logged in, etc.
    func confirm(startPhotoPlayback intent: INStartPhotoPlaybackIntent, completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        let response = INStartPhotoPlaybackIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }

    // Required method
    // We can pass additional information here as part of NSUserActivity.userinfo
    func handle(startPhotoPlayback intent: INStartPhotoPlaybackIntent, completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        let response = INStartPhotoPlaybackIntentResponse(code: .continueInApp, userActivity: activity)
        completion(response)
    }
}

//
//  IntentHandler.swift
//  SiriExtension
//
//  Created by Akshay Bharath on 9/11/16.
//  Copyright © 2016 Akshay Bharath. All rights reserved.
//

import Intents
import Photos

class IntentHandler: INExtension, INStartPhotoPlaybackIntentHandling, INSendMessageIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
// MARK: - INStartPhotoPlaybackIntentHandling
    //TODO ALL

//    func resolveDateCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
//                            with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {
//        if let dateCreated = intent.dateCreated {
//            completion(INDateComponentsRangeResolutionResult.success(with: dateCreated))
//        }
//    }

//    func resolveAlbumName(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
//                          with completion: @escaping (INStringResolutionResult) -> Void) {
//        if let album = intent.albumName, (intent.locationCreated == nil) {
//            let userAlbumsOptions = PHFetchOptions()
//            userAlbumsOptions.predicate = NSPredicate.init(format: "estimatedAssetCount > %@", 0)
//            
//            let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: userAlbumsOptions)
//            userAlbums.enumerateObjects({
//                (collection, index, stop) in
//                
//                if let albumName = collection.localizedTitle {
//                    if (album == albumName) {
//                        completion(INStringResolutionResult.success(with: albumName))
//                        return
//                    }
//                }
//            })
//            
//            // Could not find album
//            completion(INStringResolutionResult.unsupported())
//        }
//    }

//    func resolvePeopleInPhoto(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
//                              with completion: @escaping ([INPersonResolutionResult]) -> Void) {
//        if let people = intent.peopleInPhoto {
//            
//            // If no people, prompt
//            if people.count == 0 {
//                completion([INPersonResolutionResult.needsValue()])
//                return
//            }
//            
//            var successResults = [INPersonResolutionResult]()
//            for person in people {
//                successResults.append(INPersonResolutionResult.success(with: person))
//            }
//            completion(successResults)
//        }
//    }

    func resolveLocationCreated(forStartPhotoPlayback intent: INStartPhotoPlaybackIntent,
                                with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if let location = intent.locationCreated {
            completion(INPlacemarkResolutionResult.success(with: location))
        } else {
            completion(INPlacemarkResolutionResult.needsValue())
        }
    }
    
    func confirm(startPhotoPlayback intent: INStartPhotoPlaybackIntent,
                 completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        let response = INStartPhotoPlaybackIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    func handle(startPhotoPlayback intent: INStartPhotoPlaybackIntent,
                completion: @escaping (INStartPhotoPlaybackIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: NSStringFromClass(INStartPhotoPlaybackIntent.self))
        activity.addUserInfoEntries(from: ["Greeting": "Watup"])

        let response = INStartPhotoPlaybackIntentResponse(code: .continueInApp, userActivity: activity)
        completion(response)
    }
    
// MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
// MARK: - INSearchForMessagesIntentHandling
    
    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
// MARK: - INSetMessageAttributeIntentHandling
    
    func handle(setMessageAttribute intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}


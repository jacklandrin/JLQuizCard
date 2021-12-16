//
//  PersistenceController.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController(inMemory: true)
    let container: NSPersistentCloudKitContainer
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CardInfoModel")
        let viewContext = container.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let storeURL = URL.storeURL(for: "group.com.jacklandrin.quizcard", databaseName: "iQRAssistant")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = storeURL
            container.persistentStoreDescriptions.first!.shouldAddStoreAsynchronously = false
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext() {
        let context = self.container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension CardInfo {
    
    static var defaultFetchRequest:NSFetchRequest<CardInfo> {
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardInfo.weight, ascending: false)]
        print("fetched the cards")
        return request
    }
    
    static func searchFetchRequest(question:String) -> NSFetchRequest<CardInfo> {
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardInfo.weight, ascending: false)]
        request.predicate = NSPredicate(format: "question CONTAINS %@", question)
        print("fetched the searched cards")
        return request
    }
    
    static var fetchResult:[CardInfo] {
        do{
            let fetchResults = try PersistenceController
                .shared
                .container
                .viewContext
                .fetch(CardInfo.defaultFetchRequest)
            if fetchResults.count > 0 {
                return fetchResults
            }
        } catch {
            
        }
        return [CardInfo]()
    }
    
    static func searchedResult(question:String) -> [CardInfo] {
        do {
            let fetchResults = try PersistenceController
                .shared
                .container
                .viewContext
                .fetch(CardInfo.searchFetchRequest(question: question))
            if  fetchResults.count > 0 {
                return fetchResults
            }
        } catch {
            
        }
        return [CardInfo]()
    }
}

extension CardGroup {
    static var defaultFetchRequest:NSFetchRequest<CardGroup> {
        let request: NSFetchRequest<CardGroup> = CardGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardGroup.groupname, ascending: true)]
        print("fetched the card group")
        return request
    }
    
    static var fetchResult: [CardGroup] {
        do {
            let fetchResults = try PersistenceController
                .shared
                .container
                .viewContext
                .fetch(CardGroup.defaultFetchRequest)
            if  fetchResults.count > 0 {
                return fetchResults
            }
        } catch {
            
        }
        return [CardGroup]()
    }
    
    public var cardArray:[CardInfo] {
        let set = cards as? Set<CardInfo> ?? []
        let array = set.sorted{
            ($0.weight, $0.id) > ($1.weight, $1.id)
        }
        return array
    }
    
    public var wrappedName:String {
        groupname ?? "default group"
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

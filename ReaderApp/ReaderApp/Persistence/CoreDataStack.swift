//
//  Core Data Stack.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ReaderApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

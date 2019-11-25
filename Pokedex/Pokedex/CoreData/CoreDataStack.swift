//
//  CoreDataStack.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pokedex")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

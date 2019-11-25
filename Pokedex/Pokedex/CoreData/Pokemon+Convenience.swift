//
//  Pokemon+Convenience.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

extension Pokemon {
    convenience init(name: String,
                    imgURLString: String?,
                    id: Int16,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.id = id
        self.imgURLString = imgURLString
    }
}

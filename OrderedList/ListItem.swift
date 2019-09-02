//
//  ListItem.swift
//  OrderedList
//
//  Created by SchwiftyUI on 9/2/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import CoreData

class ListItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var order: Int
}

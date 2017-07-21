//
//  HeroFeatures.swift
//  NewGame
//
//  Created by Baizhan Zhumagulov on 2017-07-21.
//  Copyright © 2017 Baizhan Zhumagulov. All rights reserved.
//

import CoreData

class Features: NSManagedObject {
    @NSManaged var diveSpeed: Int
    @NSManaged var oxygenLoseRate: Int
}

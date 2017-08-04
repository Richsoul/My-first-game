//
//  User.swift
//  EscapeTheFall
//
//  Created by Inho on 7/31/17.
//  Copyright © 2017 Inho Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    let uid: String
    let coins: Int
    private static var _current: User?
    
    static var loggedIn: Bool {
        return _current != nil
    }
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: Current user doesn't exist")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: "CurrentUser")
        }
        _current = user
    }
    
    init(uid: String, coins: Int) {
        self.uid = uid
        self.coins = coins
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let coins = dict["coins"] as? Int else {
                return nil
        }
        self.uid = snapshot.key
        self.coins = coins
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "UID") as? String else {
                return nil
        }
        
        self.uid = uid
        self.coins = aDecoder.decodeInteger(forKey: "coins")
        
    }
}

extension User : NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "UID")
        aCoder.encode(coins, forKey: "coins")
    }
}

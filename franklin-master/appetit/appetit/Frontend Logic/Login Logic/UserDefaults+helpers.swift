//
//  UserDefaults+helpers.swift
//  audible
//
//  Created by Brian Voong on 10/3/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case email
        case wordp
        case fname
        case lname
        case maxcal
        
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func setEmail(value: String) {
        set(value, forKey: UserDefaultsKeys.email.rawValue)
        synchronize()
    }
    func setFirstName(value: String) {
        set(value, forKey: UserDefaultsKeys.fname.rawValue)
        synchronize()
    }
    func setLastName(value: String) {
        set(value, forKey: UserDefaultsKeys.lname.rawValue)
        synchronize()
    }
    func setMaxCal(value: String) {
        set(value, forKey: UserDefaultsKeys.maxcal.rawValue)
        synchronize()
    }
    
    func setWord(value: String) {
        set(value, forKey: UserDefaultsKeys.wordp.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
}

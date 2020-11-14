//
//  UserEntity.swift
//  appetit
//
//  Created by Mark Kang on 4/4/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation
import CoreData

public struct UserEntity{
    
    let managedUser: NSManagedObject;
    let firstName: String;
    let lastName: String;
    let email: String;
    let maxCaloriesPerMeal: Int;
    
    init(user: NSManagedObject) {
        managedUser = user
        firstName = user.value(forKey: "firstName") as! String
        lastName = user.value(forKey: "lastName") as! String
        email = user.value(forKey: "email") as! String
        maxCaloriesPerMeal = user.value(forKey: "maxCaloriesPerMeal") as! Int
    }
    
    func getFirstName() -> String{
        return firstName
    }
    
    func getLastName() -> String{
        return lastName
    }
    
    func getEmail() -> String{
        return email
    }
    
    func getMaxCaloriesPerMeal() -> Int{
        return maxCaloriesPerMeal
    }
}

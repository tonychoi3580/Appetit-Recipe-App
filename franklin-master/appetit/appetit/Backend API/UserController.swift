//
//  UserInfoAPI.swift
//  appetit
//
//  Created by Mark Kang on 3/28/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import Foundation

class UserController{
    let userDataHandler: DataHandler;
    
    init() {
        userDataHandler = DataHandler()
    }
    /*Use for log in and check if the user is registered*/
    func isValidUser(email:String, password:String) throws -> Bool{
        do{
            let userResult = try userDataHandler.getUserInfo(email: email, password: password)
            return userResult.count == 1
        }catch{
            throw ErrorMessage.ErrorCodes.dataSearchFailed
        }
    }
    /*Returns a UserEntity struct that contains user's information*/
    func getUser(email:String, password: String) throws -> UserEntity{
         do{
            let userResult = try userDataHandler.getUserInfo(email: email, password: password)
            let userEntity = UserEntity(user: userResult[0])
            return userEntity
         }catch{
            throw ErrorMessage.ErrorCodes.dataSearchFailed
         }
    }
    /*Use for sign up feature. Throws an error if the user already exists*/
    func saveUser(email: String, password: String, firstName: String, lastName: String, maxCaloriesPerMeal: Int) throws{
        guard try !isValidUser(email: email, password: password) else{
            throw ErrorMessage.ErrorCodes.userExists
        }
        let user = userDataHandler.getDatabaseObject(entity: "User")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        user.setValue(firstName, forKey: "firstName")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(maxCaloriesPerMeal, forKey: "maxCaloriesPerMeal")
        do{
            try userDataHandler.save()
        } catch {
            throw ErrorMessage.ErrorCodes.dataSaveFailed
        }
    }
    
    /*Delete the user from our User table*/
    func deleteUser(email: String) throws{
        do{
            try userDataHandler.deleteUser(email: email)
        }catch{
            throw ErrorMessage.ErrorCodes.dataSearchFailed
        }
    }
    
    /*Update user information*/
    func updateUser(email: String, password: String, firstName: String, lastName: String, maxCaloriesPerMeal: Int) throws{
        try deleteUser(email: email)
        try saveUser(email: email, password: password, firstName: firstName, lastName: lastName, maxCaloriesPerMeal: maxCaloriesPerMeal)
    }
    
}

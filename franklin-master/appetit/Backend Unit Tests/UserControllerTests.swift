//
//  Backend_Unit_Tests.swift
//  Backend Unit Tests
//
//  Created by Mark Kang on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import XCTest
@testable import appetit
import CoreData

class UserControllerTests: XCTestCase {

    let testEmail = "test@gmail.com"
    let testPassword = "testpassword"
    let testFirstName = "testFirstName"
    let testLastName = "testLastName"
    let testMaxCaloriesPerMeal = 29
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let entity = "User"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "(email  =  %@) AND (password = %@)", testEmail, testPassword)
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUp(){
        let testUser = UserController()
        var signUpStatus: Bool;
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            signUpStatus = true
        }catch ErrorMessage.ErrorCodes.dataSaveFailed{
            signUpStatus = false
            print("data save failed")
        }catch ErrorMessage.ErrorCodes.userExists{
            signUpStatus = false
            print("user exists")
        }catch{
            signUpStatus = false
            print("unknown error")
        }
        XCTAssertEqual(true, signUpStatus)
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            signUpStatus = true
        }catch ErrorMessage.ErrorCodes.dataSaveFailed{
            signUpStatus = false
        }catch ErrorMessage.ErrorCodes.userExists{
            signUpStatus = false
        }catch{
            signUpStatus = false
        }
         XCTAssertEqual(false, signUpStatus)
    }
    
    func testLogIn() {
        let testUser = UserController()
        let logInStatus: Bool
        var errorStatus = false;
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            logInStatus = try testUser.isValidUser(email: testEmail, password: testPassword)
            XCTAssertEqual(true, logInStatus)
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }

    func testGetUserInfo() {
        let testUser = UserController()
        var errorStatus = false
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            let userResult = try testUser.getUser(email: testEmail, password: testPassword)
            XCTAssertEqual(userResult.firstName, testFirstName)
            XCTAssertEqual(userResult.lastName, testLastName)
            XCTAssertEqual(userResult.email, testEmail)
            XCTAssertEqual(userResult.maxCaloriesPerMeal, testMaxCaloriesPerMeal)
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }
    
    func testDeleteUser(){
        let testUser = UserController()
        var errorStatus = false
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            try testUser.deleteUser(email: testEmail)
            let deleteStatus = try testUser.isValidUser(email: testEmail, password: testPassword)
            XCTAssertEqual(false, deleteStatus)
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }
    
    func testUpdateUser(){
        let testUser = UserController()
        var errorStatus = false
        do{
            try testUser.saveUser(email: testEmail, password: testPassword, firstName: testFirstName
            , lastName: testLastName, maxCaloriesPerMeal: testMaxCaloriesPerMeal)
            try testUser.updateUser(email: testEmail, password: testPassword, firstName: "changed", lastName: "changed", maxCaloriesPerMeal: 30)
            let userResult = try testUser.getUser(email: testEmail, password: testPassword)
            XCTAssertEqual(userResult.firstName, "changed")
            XCTAssertEqual(userResult.lastName, "changed")
            XCTAssertEqual(userResult.email, testEmail)
            XCTAssertEqual(userResult.maxCaloriesPerMeal, 30)
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }

}

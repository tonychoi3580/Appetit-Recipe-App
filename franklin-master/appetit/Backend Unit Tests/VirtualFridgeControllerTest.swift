//
//  VirtualFridgeControllerTest.swift
//  Backend Unit Tests
//
//  Created by Mark Kang on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import XCTest
@testable import appetit
import CoreData

class VirtualFridgeControllerTest: XCTestCase {
    let testEmail = "test@gmail.com"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let entity = "VirtualFridge"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "email = %@", testEmail)
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

    func testAddIngredients(){
        let testUser = VirtualFridgeController()
        var errorStatus = false
        do{
            try testUser.addIngredient(email: testEmail, ingredient: "tomatoes", servings: 10)
            try testUser.addIngredient(email: testEmail, ingredient: "bananas", servings: 5)
            try testUser.addIngredient(email: testEmail, ingredient: "lettuce", servings: 21)
            
            let testList = try testUser.getUserIngredients(email: testEmail)
            let foods = ["tomatoes", "bananas", "lettuce"]
            var i = 0
            for ingredient in testList{
                XCTAssertEqual(foods[i], ingredient.ingredient)
                i = i + 1
            }
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }
    
    func testSubtractIngredients(){
        let testUser = VirtualFridgeController()
        var errorStatus = false
        do{
            try testUser.addIngredient(email: testEmail, ingredient: "tomatoes", servings: 10)
            try testUser.addIngredient(email: testEmail, ingredient: "bananas", servings: 5)
            try testUser.addIngredient(email: testEmail, ingredient: "lettuce", servings: 21)
            
            try testUser.subtractIngredient(email: testEmail, ingredient: "tomatoes", servings: 5)
            let testList1 = try testUser.getUserIngredients(email: testEmail)
            let tomato = testList1[0].servings
            
            /*Tests that the subtraction of servings feature works**/
            XCTAssertEqual(5, tomato)
            try testUser.subtractIngredient(email: testEmail, ingredient: "tomatoes", servings: 5)
            let testList2 = try testUser.getUserIngredients(email: testEmail)
            /*Tests that the deleting ingredients when no leftover servings, feature works*/
            XCTAssertEqual(2, testList2.count)
            try testUser.subtractIngredient(email: testEmail, ingredient: "bananas", servings: 10)
            let testList3 = try testUser.getUserIngredients(email: testEmail)
            /*Tests that the deleting ingredients when request servings is greater than existing servings amount, feature works*/
            XCTAssertEqual(1, testList3.count)
        }catch{
            errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
        var caughtError = false
        do{
            try testUser.subtractIngredient(email: testEmail, ingredient: "tomatoes", servings: 5)
        }catch{
            caughtError = true
        }
        XCTAssertEqual(true, caughtError)
        
    }
    
    
    func testUpdateIngredient(){
        let testUser = VirtualFridgeController()
        var errorStatus = false
        do{
            try testUser.addIngredient(email: testEmail, ingredient: "tomatoes", servings: 10)
            try testUser.addIngredient(email: testEmail, ingredient: "bananas", servings: 5)
            try testUser.addIngredient(email: testEmail, ingredient: "lettuce", servings: 21)
            try testUser.updateIngredient(email: testEmail, ingredient: "tomatoes", servings: 500)
            try testUser.updateIngredient(email: testEmail, ingredient: "bananas", servings: 400)
            try testUser.updateIngredient(email: testEmail, ingredient: "lettuce", servings: 300)
            let testList = try testUser.getUserIngredients(email: testEmail)
            let tomatoes = testList[0]
            let bananas = testList[1]
            let lettuce = testList[2]
            XCTAssertEqual(tomatoes.servings, 500)
            XCTAssertEqual(tomatoes.ingredient, "tomatoes")
            XCTAssertEqual(bananas.servings, 400)
            XCTAssertEqual(lettuce.servings, 300)
        }catch{
           errorStatus = true
        }
        XCTAssertEqual(false, errorStatus)
    }

}

//
//  UserInfoDataHandler.swift
//  appetit
//
//  Created by Mark Kang on 3/28/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import UIKit
import CoreData

class DataHandler{
    let appDelegate: AppDelegate;
    let context: NSManagedObjectContext;
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    /*NS Managed user object needed for database saves*/
    func getDatabaseObject(entity: String) -> NSManagedObject{
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: context)
        let user = NSManagedObject(entity: userEntity!, insertInto: context)
        return user
    }
    
    /*Search specific user*/
    func getUserInfo(email: String, password: String) throws -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "(email  =  %@) AND (password = %@)", email, password)
        do{
            let result = try fufillRequest(request: request)
            return result
        }catch{
            throw error
        }
    }
    
    func deleteUser(email: String) throws{
        let entity = "User"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "email  =  %@", email)
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            try save()
        } catch let error as NSError {
            throw error
        }
    }
    
    func getVirtualFridgeIngredients(email: String) throws -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VirtualFridge")
        request.predicate = NSPredicate(format: "email  =  %@", email)
        do{
            let result = try fufillRequest(request: request)
            return result
        }catch{
            throw error
        }
    }
    
    func getIngredient(email: String, ingredient: String) throws -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VirtualFridge")
        request.predicate = NSPredicate(format: "(email  =  %@) AND (ingredient = %@)", email, ingredient)
        do{
            let result = try fufillRequest(request: request)
            return result
        }catch{
            throw error
        }
    }
    
    func deleteIngredient(email: String, ingredient: String) throws{
        let entity = "VirtualFridge"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "(email  =  %@) AND (ingredient = %@)", email, ingredient)
        do
        {
            let results = try context.fetch(fetchRequest)
            guard results.count > 0 else{
                throw ErrorMessage.ErrorCodes.ingredientDoesNotExist
            }
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            try save()
        } catch let error as NSError {
            throw error
        }
    }
    
    func getUserRecipes(email: String) throws -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        request.predicate = NSPredicate(format: "email  =  %@", email)
        do{
            let result = try fufillRequest(request: request)
            return result
        }catch{
            throw error
        }
    }

    /*Saves user info in sign up feature. Returns true if saved successfully, else throws error*/
    func save() throws{
        do{
            try context.save()
        } catch {
            throw error
        }
    }
    
    func fufillRequest(request: NSFetchRequest<NSFetchRequestResult>) throws -> [NSManagedObject]{
        do{
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        }catch{
            throw error
        }
    }
}

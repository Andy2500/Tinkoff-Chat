//
//  CoreDataService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 02.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit
import CoreData

class StorageService: NSObject, DataUserService {
    
    var stack = CoreDataStack()
    var delegate: StorageServiceDelegate?
    
    func saveUser(_ dictionary: Dictionary<String, Any?>?){
        if let stackSaveContext = stack.saveContext {
            if let appUser = AppUser.findOrInsertAppUser(in: stackSaveContext){
                if let current = appUser.currentUser{
                    if let dictionary = dictionary {
                        for value in dictionary{
                            current.setValue(value.value, forKey: value.key)
                        }
                        
                        stack.performSave(context: stackSaveContext, completionHandler: delegate?.userSaved)
                    }
                }
            }
        }
    }
    
    func readUser(){
        if let stackMainContext = stack.mainContext {
            if let appUser = AppUser.findOrInsertAppUser(in: stackMainContext){
                if let current = appUser.currentUser{
                    delegate?.userLoaded(user: current)
                    return
                }
            }
        }

        delegate?.userLoaded(user: nil)
    }
}

extension AppUser {

    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser?{
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not avaliable in context!")
            assert(false)
            return nil
        }
        
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUser found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) ->AppUser?{
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser{
            if appUser.currentUser == nil {
                let currentUser = User.findOrInsertUser(in: context)
                appUser.currentUser = currentUser
            }
            return appUser
        }
        return nil
    }
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>?{
        let templateName = "AppUser"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName) !")
            return nil
        }
        return fetchRequest
    }
}

extension User {
    static func findOrInsertUser(in context: NSManagedObjectContext) -> User?{
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not avaliable in context!")
            assert(false)
            return nil
        }
        
        var user: User?
        guard let fetchRequest = User.fetchRequestUser(model: model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple User found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User: \(error)")
        }
        
        if user == nil {
            user = User.insertUser(in: context)
        }
        
        return user
    }
    
    static func fetchRequestUser(model: NSManagedObjectModel) -> NSFetchRequest<User>?{
        let templateName = "User"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName) !")
            return nil
        }
        return fetchRequest
    }
    
    static func insertUser(in context: NSManagedObjectContext) ->User?{
        if let User = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User{
            return User
        }
        return nil
    }
}

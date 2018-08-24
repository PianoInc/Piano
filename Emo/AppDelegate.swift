//
//  AppDelegate.swift
//  Piano
//
//  Created by Kevin Kim on 2018. 8. 12..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let window = window,
            let rootViewController = window.rootViewController,
            let mainViewController = rootViewController.childViewControllers.first as? MainCollectionViewController {
            mainViewController.persistentContainer = self.persistentContainer
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        saveNoteCount()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Emo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    private func saveNoteCount() {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        if let fetched = try? persistentContainer.viewContext.fetch(request) {
            UserDefaults.standard.set(fetched.count, forKey: "NoteCount")
        }
    }
}

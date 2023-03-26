//
//  Persistence.swift
//  KeyDays
//
//  Created by Кирилл Сутырь on 15.02.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "KeyDaysModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(completion: @escaping (Error?)->() = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func delete(object: NSManagedObject, completion: @escaping (Error?)->() = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
    
    func addKeyDate(name: String, date: Date,imageData: Data, isFavourite: Bool, notificationsEnabled: Bool) {
        let keyDate = KeyDay(context: container.viewContext)
        keyDate.id = UUID()
        keyDate.dateName = name
        keyDate.imageData = imageData
        keyDate.keyDate = date
        keyDate.isFavourite = isFavourite
        keyDate.notificationsEnabled = notificationsEnabled
        
        save()
    }
    
    func editKeyDate(keyDate: KeyDay, name: String, date: Date,imageData: Data, isFavourite: Bool, notificationsEnabled: Bool) {
        keyDate.id = UUID()
        keyDate.dateName = name
        keyDate.imageData = imageData
        keyDate.keyDate = date
        keyDate.isFavourite = isFavourite
        keyDate.notificationsEnabled = notificationsEnabled
        
        save()
    }
}

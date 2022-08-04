//
//  DataBaseManager.swift
//  Stats
//
//  Created by max on 16.05.2022.
//

import Foundation
import CoreData

protocol ListOfCountriesCoreDataManager: AnyObject {
    
    func saveContext(backgroundContext: NSManagedObjectContext?)
    func fetchAllCountriesData (completion: @escaping (Result<[Model]?, Error>) -> Void)
    
    var viewContext: NSManagedObjectContext {get set}
    var persistentContainer: NSPersistentContainer! {get set}
    func prepare(newPersistentContainer: NSPersistentContainer?)
}

class ListOfCountriesCoreDataManagerImplementation: ListOfCountriesCoreDataManager {
    
    static let shared = ListOfCountriesCoreDataManagerImplementation()
    var persistentContainer: NSPersistentContainer!
    
    private init() {
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        
        return self.persistentContainer.viewContext
    }()
    
    func prepare(newPersistentContainer: NSPersistentContainer? = nil)
    {
        guard let newContainer = newPersistentContainer else {
            let container = NSPersistentContainer(name: "Data")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            self.persistentContainer = container
            return
        }
        self.persistentContainer = newContainer
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllCountriesData (completion: @escaping (Result<[Model]?, Error>) -> Void) {
        
        viewContext.perform {
            let fetchRequest: NSFetchRequest = Model.fetchRequest()
            
            do {
                let models = try self.viewContext.fetch(fetchRequest)
                completion(.success(models))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }
}

enum CoreDataManagerErrors: Error {
    case unwrapCountryDataError
    case getViewContextError
}
extension CoreDataManagerErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unwrapCountryDataError:
            return NSLocalizedString("Couldnt unwrap country data", comment: "Unwrapping data error")
        case .getViewContextError:
            return NSLocalizedString("Couldnt get viewContext", comment: "CoreData error")
        }
    }
}

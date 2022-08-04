//
//  CoreDataManagerAllCountries.swift
//  Stats
//
//  Created by max on 30.07.2022.
//

import Foundation
import CoreData

protocol AllCountriesCoreDataManager: AnyObject {
    
    func saveContext(backgroundContext: NSManagedObjectContext?)
    func fetchAllCountriesGlobalData (completion: @escaping (Result<[AllCoutriesGlobalData]?, Error>) -> Void)
    func fetchAllCountriesDataForCharts (completion: @escaping (Result<[AllCountriesDataForCharts]?, Error>) -> Void)
    func prepare(newPersistentContainer: NSPersistentContainer?)
    var viewContext: NSManagedObjectContext {get set}
    var persistentContainer: NSPersistentContainer! {get set}
}

class AllCountriesCoreDataManagerImplementation: AllCountriesCoreDataManager {
    
    static let shared = AllCountriesCoreDataManagerImplementation()
    var persistentContainer: NSPersistentContainer!
    
    private init() {}
    
    /// Function initializes with default PersistentCoontainer
    /// - Parameter newPersistentContainer: another PersistentContainer to init
    func prepare(newPersistentContainer: NSPersistentContainer? = nil)
    {
        guard let newContainer = newPersistentContainer else {
            let container = NSPersistentContainer(name: "AllCountriesData")
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
    
    
    lazy var viewContext: NSManagedObjectContext = {
        
        return persistentContainer.viewContext
    }()
    
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
    
    func fetchAllCountriesGlobalData (completion: @escaping (Result<[AllCoutriesGlobalData]?, Error>) -> Void) {
        
        viewContext.perform {
            let fetchRequest: NSFetchRequest = AllCoutriesGlobalData.fetchRequest()
            do {
                let models = try self.viewContext.fetch(fetchRequest)
                completion(.success(models))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllCountriesDataForCharts (completion: @escaping (Result<[AllCountriesDataForCharts]?, Error>) -> Void) {
        
        viewContext.perform {
            let fetchRequest: NSFetchRequest = AllCountriesDataForCharts.fetchRequest()
            do {
                let models = try self.viewContext.fetch(fetchRequest)
                completion(.success(models))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }
}

enum AllCountriesCoreDataManagerErrors: Error {
    case unwrapCountryDataError
    case getViewContextError
}
extension AllCountriesCoreDataManagerErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unwrapCountryDataError:
            return NSLocalizedString("Couldn`t unwrap country data", comment: "Unwrapping data error")
        case .getViewContextError:
            return NSLocalizedString("Couldn`t get viewContext", comment: "CoreData error")
        }
    }
}

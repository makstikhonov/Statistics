//
//  StatsTests.swift
//  StatsTests
//
//  Created by max on 22.07.2022.
//

import XCTest
import Foundation
import CoreData
import Moya

@testable import Stats

class StatsTests: XCTestCase {
    
    var storageManager: ListOfCountriesCoreDataManager!
    var networkManagerOnline: NetworkManager<ListOfCountriesService>!
    var networkManagerOffline: NetworkManager<ListOfCountriesService>!
    var listOfCountriesDataManager: ListOfCountriesDataManager!
    var listOfCountriesDataManagerOfflineMode: ListOfCountriesDataManager!
    
    /// Usess to emulate offline mode in tests
    let customEndpointClosure = { (target: ListOfCountriesService) -> Endpoint in
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(500 , target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    
    static let sharedMom: NSManagedObjectModel = {
        let modelURL = Bundle(for: ListOfCountriesCoreDataManagerImplementation.self).url(forResource: "Data", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /// CoreData Persisitent container for tests
    let persistentContainer: NSPersistentContainer = {
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.url = URL(fileURLWithPath: "/dev/null")
        persistentStoreDescription.shouldMigrateStoreAutomatically = true
        persistentStoreDescription.shouldInferMappingModelAutomatically = true
        persistentStoreDescription.shouldAddStoreAsynchronously = false
        let container = NSPersistentContainer(name: "Data", managedObjectModel: StatsTests.sharedMom)
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    override func setUpWithError() throws {
        
        storageManager = ListOfCountriesCoreDataManagerImplementation.shared
        storageManager.prepare(newPersistentContainer: persistentContainer)
        
        networkManagerOnline = NetworkManager(stubClosure:  MoyaProvider.immediatelyStub)
        networkManagerOffline = NetworkManager(stubClosure:  MoyaProvider.immediatelyStub, endpointClosure: customEndpointClosure)
        
        listOfCountriesDataManager = ListOfCountriesDataManagerImplementation(networkManager: networkManagerOnline, storageManager: storageManager)
        listOfCountriesDataManagerOfflineMode = ListOfCountriesDataManagerImplementation(networkManager: networkManagerOffline, storageManager: storageManager)
    }
    
    override func tearDownWithError() throws {
        
        listOfCountriesDataManager = nil
        listOfCountriesDataManagerOfflineMode = nil
        storageManager = nil
        networkManagerOnline = nil
        networkManagerOffline = nil
    }
    
    func testSaveAllCountriesSummaryDataToCoreDataSuccesfuly() throws {
        // given
        
        var expectedResult: [Country]? {
            let testData = ListOfCountriesTestData().testObtainSummaryData
            
            guard let json = try? JSONDecoder().decode(StatisticListOfCountries.self, from: testData) else {return nil}
            return json.countries
        }
        var recievedResult: [Country]?
        let expectationSummary = expectation(description: "Expectation in " + #function)
        // when
        //Obtain data from server and save it to CoreData
        listOfCountriesDataManager.obtainAndSaveSummaryCountryData {[weak self] result in
            switch(result){
            case .success(_):
                //Try to obtain saved data from CoreData
                self?.storageManager.fetchAllCountriesData { result in
                    var resultArray: [Country] = []
                    
                    switch result {
                    case .success(let models):
                        guard let countries = models else { XCTFail()
                            return}
                        for data in countries {
                            guard let country = data.country else { XCTFail()
                                return}
                            resultArray.append(country)
                        }
                        recievedResult = resultArray
                    case .failure(_):
                        recievedResult = nil
                    }
                    expectationSummary.fulfill()
                }
            case .failure(_):
                recievedResult = nil
            }
            
        }
        // then
        waitForExpectations(timeout: 1.0) { (error) in
            
            if error != nil {
                XCTFail()
            }
            
            guard let recievedCountries = recievedResult else {XCTFail()
                return}
            guard let expectedCountries = expectedResult else {XCTFail()
                return}
            
            let result = recievedCountries.sorted { $0.country < $1.country }.elementsEqual(expectedCountries.sorted { $0.country < $1.country }) {
                $0.country == $1.country && $0.countryCode == $1.countryCode
            }
            XCTAssert(result)
        }
    }
    
    func testObtainAllCountriesSummaryDataOnlineModeSuccesfuly() throws {
        // given
        var expectedResult: [Country]? {
            let testData = ListOfCountriesTestData().testObtainSummaryData
            
            guard let json = try? JSONDecoder().decode(StatisticListOfCountries.self, from: testData) else {return nil}
            return json.countries
        }
        var recievedResult: [Country]?
        let expectationSummary = expectation(description: "Expectation in " + #function)
        // when
        //Try to obtain data from server
        listOfCountriesDataManager.obtainAndSaveSummaryCountryData { result in
            switch(result){
            case .success(let data):
                recievedResult = data
            case .failure(_):
                recievedResult = nil
            }
            expectationSummary.fulfill()
        }
        // then
        waitForExpectations(timeout: 1.0) { (error) in
            
            if error != nil {
                XCTFail()
            }
            guard let recievedCountries = recievedResult else {XCTFail()
                return}
            guard let expectedCountries = expectedResult else {XCTFail()
                return}
            
            let result = recievedCountries.sorted { $0.country < $1.country }.elementsEqual(expectedCountries.sorted { $0.country < $1.country }) {
                $0.country == $1.country && $0.countryCode == $1.countryCode
            }
            XCTAssert(result)
        }
    }
    
    func testObtainAllCountriesSummaryDataOfflineModeSuccesfuly() throws {
        // given
        var expectedResult: [Country]? {
            let testData = ListOfCountriesTestData().testObtainSummaryData
            
            guard let json = try? JSONDecoder().decode(StatisticListOfCountries.self, from: testData) else {return nil}
            return json.countries
        }
        var recievedResult: [Country]?
        let expectationSummary = expectation(description: "Expectation in " + #function)
        // when
        //Save expected data to CoreData
        let viewContext = storageManager.viewContext
        guard let countries = expectedResult else {XCTFail()
            return}
        for country in countries {
            let countriesData = Model(context: viewContext)
            countriesData.country = country
            countriesData.countryCode = country.countryCode
            storageManager.saveContext(backgroundContext: nil)
        }
        //Try to obtain data from CoreData in offline mode
        self.listOfCountriesDataManagerOfflineMode.obtainAndSaveSummaryCountryData { result in
            switch(result){
            case .success(let data):
                recievedResult = data
                expectationSummary.fulfill()
            case .failure(_):
                recievedResult = nil
            }
        }
        
        // then
        waitForExpectations(timeout: 1.0) { (error) in
            
            if error != nil {
                XCTFail()
            }
            guard let recievedCountries = recievedResult else {XCTFail()
                return}
            guard let expectedCountries = expectedResult else {XCTFail()
                return}
            
            let result = recievedCountries.sorted { $0.country < $1.country }.elementsEqual(expectedCountries.sorted { $0.country < $1.country }) {
                $0.country == $1.country && $0.countryCode == $1.countryCode
            }
            XCTAssert(result)
        }
    }
    
    func testObtainFilteredResultWhenTypingInSearchbarSuccesfuly() throws {
        // given
        let dataToSearch = [Country(country: "russia", countryCode: "ru", slug: "russia", newConfirmed: 0, totalConfirmed: 0, newDeaths: 0, totalDeaths: 0, newRecovered: 0, totalRecovered: 0, date: "")]
        
        let expectedResult = dataToSearch
        
        var recievedResult: [Country]!
        let textToSearch = "rus"
        let expectationSummary = expectation(description: "Expectation in " + #function)
        
        // when
        listOfCountriesDataManager.obtainFilteredResults(searchText: textToSearch, dataToSearch: dataToSearch) { result in
            
            recievedResult = result
            expectationSummary.fulfill()
        }
        // then
        waitForExpectations(timeout: 1.0) { (error) in
            
            if error != nil {
                XCTFail()
            }
            XCTAssertEqual(expectedResult, recievedResult)
        }
    }
}

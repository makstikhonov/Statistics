//
//  DataManagerListOfCountries.swift
//  Stats
//
//  Created by max on 05.05.2022.
//

import Foundation
import Moya
import SDWebImage

protocol ListOfCountriesDataManager: AnyObject {
    
    /// Function obtains new covid data from server and saves it to the CoreData. In offline mode function tries to obtain data from CoreData
    /// - Parameter completion:
    func obtainAndSaveSummaryCountryData(completion: @escaping (Result<[Country], Error>) -> Void)
    /// Function obtains image of the country flag and stores it in cache. Uses SdwebImage
    /// - Parameters:
    ///   - countryCode: country code
    ///   - completion: image in Data format
    func getFlagImageForTheCountry(countryCode: String,  completion: @escaping (Result<Data, Error>) -> Void)
    /// Function is obtaining new filtered list of countries while typing in search bar.
    /// - Parameters:
    ///   - searchText: text to search
    ///   - dataToSearch: data to search in
    ///   - completion: result
    func obtainFilteredResults(searchText: String, dataToSearch: [Country] ,completion: @escaping ([Country]) -> Void)
}

class ListOfCountriesDataManagerImplementation: ListOfCountriesDataManager{
    
    private var storageManager: ListOfCountriesCoreDataManager!
    private let networkManager: NetworkManager<ListOfCountriesService>!
    
    init(networkManager: NetworkManager<ListOfCountriesService> = NetworkManager<ListOfCountriesService>(),
         storageManager: ListOfCountriesCoreDataManager = ListOfCountriesCoreDataManagerImplementation.shared ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    func obtainAndSaveSummaryCountryData(completion: @escaping (Result<[Country], Error>) -> Void) {
        
        networkManager.dataProvider.request(.obtainSummary) {[weak self] result in
            switch result {
            case .success(let data):
                do
                {
                    let _ = try data.filterSuccessfulStatusCodes()
                    
                    guard let json = try? JSONDecoder().decode(StatisticListOfCountries.self, from: data.data) else {
                        return completion(.failure(ListOfCountriesDataManagerErrors.jsonParseError))}
                    
                    guard let viewContext = self?.storageManager.viewContext else {return completion(.failure(CoreDataManagerErrors.getViewContextError))}
                    for country in json.countries {
                        let countriesData = Model(context: viewContext)
                        countriesData.country = country
                        countriesData.countryCode = country.countryCode
                        self?.storageManager.saveContext(backgroundContext: nil)
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(json.countries))
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    self?.storageManager.fetchAllCountriesData { result in
                        var resultArray: [Country] = []
                        
                        switch result {
                        case .success(let models):
                            guard let countries = models else {return completion(.failure(ListOfCountriesDataManagerErrors.unwrapCountryDataError))}
                            
                            for data in countries {
                                guard let country = data.country else {return completion(.failure(ListOfCountriesDataManagerErrors.unwrapCountryDataError))}
                                resultArray.append(country)
                            }
                            DispatchQueue.main.async {
                                completion(.success(resultArray))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    completion(.failure(error))
                    
                }
                
            case .failure(let error):
                self?.storageManager.fetchAllCountriesData { result in
                    var resultArray: [Country] = []
                    
                    switch result {
                    case .success(let models):
                        guard let countries = models else {return completion(.failure(ListOfCountriesDataManagerErrors.unwrapCountryDataError))}
                        
                        for data in countries {
                            guard let country = data.country else {return completion(.failure(ListOfCountriesDataManagerErrors.unwrapCountryDataError))}
                            resultArray.append(country)
                        }
                        DispatchQueue.main.async {
                            completion(.success(resultArray))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    
    func getFlagImageForTheCountry(countryCode: String,  completion: @escaping (Result<Data, Error>) -> Void) {
        
        let Url: String = "https://countryflagsapi.com/png/"
        
        SDWebImageManager.shared.loadImage(
            with: URL(string:Url + (countryCode)),
            options: [.highPriority, .progressiveLoad],
            progress: { (receivedSize, expectedSize, url) in
                //Progress tracking code
            },
            completed: {(image, data, error, cacheType, finished, url) in
                
                if let downloadedImageData = data, finished {
                    DispatchQueue.main.async {
                        completion(.success(downloadedImageData))
                    }
                } else {
                    guard let downloadError = error else { return }
                    completion(.failure(downloadError))
                }
            }
        )
    }
    
    func obtainFilteredResults(searchText: String, dataToSearch: [Country] ,completion: @escaping ([Country]) -> Void) {
        
        var filteredResult: [Country] = []
        
        filteredResult = dataToSearch.filter ({ (data: Country?) -> Bool in
            guard let stringMatch = data?.country.lowercased().contains(searchText.lowercased())
            else {return false}
            
            return stringMatch
        })
        
        DispatchQueue.main.async {
            completion(filteredResult)
        }
    }
}

enum ListOfCountriesService {
    case obtainSummary
}

extension ListOfCountriesService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.covid19api.com")!
    }
    
    var path: String {
        switch self{
        case .obtainSummary:
            return "/summary"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .obtainSummary:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .obtainSummary:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        switch self{
        case .obtainSummary:
            return ListOfCountriesTestData().testObtainSummaryData
        }
    }
}

enum ListOfCountriesDataManagerErrors: Error {
    case jsonParseError
    case unwrapCountryDataError
    case unwrapImageDataError
    
}
extension ListOfCountriesDataManagerErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .jsonParseError:
            return NSLocalizedString("JSON parse error", comment: "JSON parse error")
        case .unwrapCountryDataError:
            return NSLocalizedString("Couldnt unwrap country data", comment: "Unwrapping data error")
        case .unwrapImageDataError:
            return NSLocalizedString("Couldnt unwrap image data", comment: "Unwrapping data error")
        }
    }
}



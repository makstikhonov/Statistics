//
//  DataManager.swift
//  Stats
//
//  Created by max on 04.05.2022.
//

import Foundation
import Moya
import Charts

protocol AllCountriesDataManager: AnyObject {
    
    /// Function obtains and stores in CoreData summary covid data from server .
    /// - Parameter completion:
    func obtainSummaryData(completion: @escaping (Result<[AllCountriesItemWrapper], Error>) -> Void)
    
    /// Function obtains from server and stores in CoreData summary covid data for charts .
    /// - Parameter completion:
    func obtainSummaryDataForChart(completion: @escaping (Result<[AllCountriesItemWrapper], Error>) -> Void)
}

class AllCountriesDataManagerImplementation: AllCountriesDataManager {

    
    private var storageManager: AllCountriesCoreDataManager!
    private let networkManager: NetworkManager<AllCountriesService>!

    init(networkManager: NetworkManager<AllCountriesService> = NetworkManager<AllCountriesService>(),
         storageManager: AllCountriesCoreDataManager = AllCountriesCoreDataManagerImplementation.shared ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    func obtainSummaryData(completion: @escaping (Result<[AllCountriesItemWrapper], Error>) -> Void) {
        //Try to obtain data from server
        networkManager.dataProvider.request(.obtainSummary) { [weak self] result in
            switch result {
            case .success(let data):
                guard let json = try? JSONDecoder().decode(StatisticAllCountries.self, from: data.data) else {
                    return completion(.failure(AllCountriesDataManagerErrors.jsonParseError))}
                
                //Save to the Core Data new obtained data from server
                guard let viewContext = self?.storageManager.viewContext else {return completion(.failure(AllCountriesCoreDataManagerErrors.getViewContextError))}
                let data = AllCoutriesGlobalData(context: viewContext)
                data.globalData = json
                data.date = json.date
                self?.storageManager.saveContext(backgroundContext: nil)
                
                //Parse raw information
                guard let result = self?.parseInformationForData(data: json) else {
                    return completion(.failure(AllCountriesDataManagerErrors.parseDataError))}
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
           
            case .failure(let error):
                //Try to obtain and parse data from CoreData if no data from server
                self?.storageManager.fetchAllCountriesGlobalData {[weak self] result in
                    
                    switch result {
                    case .success(let models):
                        guard let globalData = models?.first else { return completion(.failure(AllCountriesDataManagerErrors.parseDataError))}
                        guard let jsonData = globalData.globalData else {return completion(.failure(AllCountriesDataManagerErrors.jsonParseError))}
                        guard let result = self?.parseInformationForData(data: jsonData) else {
                            return completion(.failure(AllCountriesDataManagerErrors.parseDataError))}
                        
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    func obtainSummaryDataForChart(completion: @escaping (Result<[AllCountriesItemWrapper], Error>) -> Void) {
        //Try to obtain data from server
        networkManager.dataProvider.request(.obtainSummaryForChart) {[weak self] result in
            switch result {
            case .success(let data):
                guard let json = try? JSONDecoder().decode([StatisticsAllCountriesForChart].self, from: data.data) else {
                    return completion(.failure(AllCountriesDataManagerErrors.jsonParseError))}
                guard let viewContext = self?.storageManager.viewContext else {return completion(.failure(AllCountriesCoreDataManagerErrors.getViewContextError))}
                
                //Save to Core Data new obtained data from server
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let dateString = df.string(from: date)
                
                let data = AllCountriesDataForCharts(context: viewContext)
                data.chartData = json
                data.date = dateString
                self?.storageManager.saveContext(backgroundContext: nil)
                
                //Parse raw information for Charts
                guard let sortedJson = self?.sortRawCovidDataByDate(data: json) else {
                    return completion(.failure(AllCountriesDataManagerErrors.sortRawDataForChartsError))}
                guard let result = self?.parseInformationForCharts(data: sortedJson) else {
                    return completion(.failure(AllCountriesDataManagerErrors.parseDataForChartsError))}
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
                
            case .failure(let error):
                //Try to obtain and parse data from CoreData if no data from server
                self?.storageManager.fetchAllCountriesDataForCharts {[weak self] result in
                    
                    switch result {
                    case .success(let models):
                        guard let globalData = models?.first else { return completion(.failure(AllCountriesDataManagerErrors.parseDataError))}
                        guard let jsonData = globalData.chartData else {return completion(.failure(AllCountriesDataManagerErrors.jsonParseError))}
                        guard let sortedJson = self?.sortRawCovidDataByDate(data: jsonData) else {
                            return completion(.failure(AllCountriesDataManagerErrors.sortRawDataForChartsError))}
                        guard let result = self?.parseInformationForCharts(data: sortedJson) else {
                            return completion(.failure(AllCountriesDataManagerErrors.parseDataForChartsError))}
                        
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    /// function sorts data from the server  by date
    /// - Parameter data: raw data from sever
    /// - Returns: sorted data
    func sortRawCovidDataByDate(data: [StatisticsAllCountriesForChart]) -> [StatisticsAllCountriesForChart]{
        
        for (index,item) in data.enumerated() {
            data[index].formatedDate = item.formatDate(inputDate: item.date)
        }
        let arrayWithCorrectDates = data.filter() { $0.formatedDate?.timeIntervalSince1970 != nil }
        let sortedDatesArray = arrayWithCorrectDates.sorted(by: { (lhs, rhs) -> Bool in return (lhs.formatedDate ?? Date()) < (rhs.formatedDate ?? Date()) })
        
        return sortedDatesArray
    }
    
    /// functions prepares data for Charts
    /// - Parameter data: data from server, sorted by date
    /// - Returns: new array of data, suitable for Charts
    func parseInformationForCharts(data: [StatisticsAllCountriesForChart]) -> [AllCountriesItemWrapper] {
        
        var newConfirmed = [Coords]()
        var totalConfirmed = [Coords]()
        var newDeaths = [Coords]()
        var totalDeaths = [Coords]()
        var newRecovered = [Coords]()
        var totalRecovered = [Coords]()
        var itemsArray = [AllCountriesItemWrapper]()
        
        for item in data {
            
            newConfirmed.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.newConfirmed)))
            totalConfirmed.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.totalConfirmed)))
            newDeaths.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.newDeaths)))
            totalDeaths.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.totalDeaths)))
            newRecovered.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.newRecovered)))
            totalRecovered.append(Coords(x: Double(item.formatedDate!.timeIntervalSince1970), y: Double(item.totalRecovered)))
        }
        
        itemsArray = [AllCountriesItemWrapper.charts(ChartItem(description: "new confirmed", coords: newConfirmed)), AllCountriesItemWrapper.charts(ChartItem(description: "total confirmed", coords: totalConfirmed)), AllCountriesItemWrapper.charts(ChartItem(description: "new deaths", coords: newDeaths)), AllCountriesItemWrapper.charts(ChartItem(description: "total deaths", coords: totalDeaths))]
        
        return itemsArray
    }
    
    /// function prepares data for information cells
    /// - Parameter data: data from server
    /// - Returns: prepared data
    func parseInformationForData(data: StatisticAllCountries) -> [AllCountriesItemWrapper] {
        
        var dataItems = [AllCountriesItemWrapper]()
        
        dataItems.append(AllCountriesItemWrapper.data(DataItem(quantity: data.global.newConfirmed, description: "New confirmed", date: data.global.formatDate(inputDate: data.date))))
        dataItems.append(AllCountriesItemWrapper.data(DataItem(quantity: data.global.totalConfirmed, description: "Total confirmed", date: data.global.formatDate(inputDate: data.date))))
        dataItems.append(AllCountriesItemWrapper.data(DataItem(quantity: data.global.newDeaths, description: "New deaths", date: data.global.formatDate(inputDate: data.date))))
        dataItems.append(AllCountriesItemWrapper.data(DataItem(quantity: data.global.totalDeaths, description: "Total deaths", date: data.global.formatDate(inputDate: data.date))))
        
        return dataItems
    }
}

enum AllCountriesService {
    case obtainSummary
    case obtainSummaryForChart
}

extension AllCountriesService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.covid19api.com")!
    }
    
    var path: String {
        switch self{
        case .obtainSummary:
            return "/summary"
        case .obtainSummaryForChart:
            return "/world"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .obtainSummary:
            return .get
        case .obtainSummaryForChart:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .obtainSummary:
            return .requestPlain
        case .obtainSummaryForChart:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        switch self{
        case .obtainSummary:
            return Data()
        case .obtainSummaryForChart:
            return Data()
        }
    }
}

enum AllCountriesDataManagerErrors: Error {
    case jsonParseError
    case parseDataError
    case sortRawDataForChartsError
    case parseDataForChartsError
}
extension AllCountriesDataManagerErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .jsonParseError:
            return NSLocalizedString("JSON parse error", comment: "JSON parse error")
        case .parseDataError:
            return NSLocalizedString("Summary covid data parse error", comment: "Data parse errror")
        case .sortRawDataForChartsError:
            return NSLocalizedString("Sort raw covid data for charts error", comment: "Data sort error")
        case .parseDataForChartsError:
            return NSLocalizedString("Parse data for charts error", comment: "Data parse errror")
        }
    }
}

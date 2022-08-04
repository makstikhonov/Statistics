//
//  ListOfCountriesPresenter.swift
//  Stats
//
//  Created by max on 18.05.2022.
//

import Foundation
import UIKit

class ListOfCountriesPresenter: ListOfCountriesViewOutput {

    var dataManager: ListOfCountriesDataManager!
    weak var view: ListOfCountriesViewInput?
    
    func obtainCountriesData()  {
        dataManager.obtainAndSaveSummaryCountryData {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.view?.countriesData = data
                    self?.view?.filteredData = data
                    self?.view?.applySnapshot(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func obtainFlagForTheCountry(indexPath: IndexPath, countryCode: String) {
        let filteredIndex = view?.countriesData.firstIndex(where: {$0.countryCode.lowercased() == countryCode.lowercased()})
        
        if view?.countriesData[filteredIndex ?? 0].flag == nil {
            dataManager.getFlagImageForTheCountry(countryCode: countryCode) { [weak self] result in
                
                switch result{
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.view?.countriesData[filteredIndex ?? 0].flag = data
                        self?.view?.updateSelectedCell(indexPath: indexPath)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func obtainFilteredResults(searchText: String, dataToSearch: [Country], completion: @escaping ([Country]) -> Void) {
        dataManager.obtainFilteredResults(searchText: searchText, dataToSearch: dataToSearch) { result in
            completion(result)
        }
    }
    
}

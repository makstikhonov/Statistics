//
//  AllCountriesPresenter.swift
//  Stats
//
//  Created by max on 14.07.2022.
//

import Foundation

class AllCountriesPresenter: AllCountriesViewOutput {
    
    var dataManager: AllCountriesDataManager!
    
    weak var view: AllCountriesViewInput?
    
    func obtainAllCountriesData() {
        dataManager.obtainSummaryData {[weak self] result in
            switch result {
            case .success(let data):
                self?.view?.mergeResults += data
                self?.view?.applySnapshot(data: self?.view?.mergeResults)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func obtainAllCountriesDataForCharts() {
        
        dataManager.obtainSummaryDataForChart {[weak self] result in
            switch result {
            case .success(let data):
                self?.view?.mergeResults += data
                self?.view?.applySnapshot(data: self?.view?.mergeResults)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

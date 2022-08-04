//
//  AllCountriesViewOutput.swift
//  Stats
//
//  Created by max on 14.07.2022.
//

import Foundation

protocol AllCountriesViewOutput: AnyObject {
    
    /// fuction obtain synnary covid data from server
    func obtainAllCountriesData()
    
    /// fuction obtain data for charts from server.
    func obtainAllCountriesDataForCharts()
}

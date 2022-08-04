//
//  ListOfCountriesViewInput.swift
//  Stats
//
//  Created by max on 18.05.2022.
//

import Foundation

protocol ListOfCountriesViewInput: AnyObject {
    
    /// data about  all countries
    var countriesData: [Country] {get set}
    
    /// data filtered for uisearchcontroller
    var filteredData: [Country] {get set}
    
    ///   function applies new data to the cells
    /// - Parameter data: new data array
    func applySnapshot(data: [Country])
    
    /// function applies new data to the cells, when type in uisearchbar
    func refreshFiltered()
    
    /// Updates only selected cell in table
    /// - Parameter indexPath: table cell  indexPath
    func updateSelectedCell(indexPath: IndexPath)
    
}

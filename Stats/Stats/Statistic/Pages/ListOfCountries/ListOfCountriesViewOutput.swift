//
//  ListOfCountriesViewOutput.swift
//  Stats
//
//  Created by max on 18.05.2022.
//

import Foundation

protocol ListOfCountriesViewOutput: AnyObject {
    
    /// function obtains summary covid data of all countries
    func obtainCountriesData()
    
    /// function obtains image of the country`s flag
    /// - Parameter countryCode: country code
    func obtainFlagForTheCountry(indexPath: IndexPath, countryCode: String)
    
    /// function obtains filtered data from all countreis data
    /// - Parameters:
    ///   - searchText: text from the UISearchBar
    ///   - dataToSearch: all countries data
    ///   - completion: new array
    func obtainFilteredResults(searchText: String, dataToSearch: [Country] ,completion: @escaping ([Country]) -> Void)
    

}

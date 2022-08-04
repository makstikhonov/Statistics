//
//  AllCountriesViewInput.swift
//  Stats
//
//  Created by max on 14.07.2022.
//

import Foundation

protocol AllCountriesViewInput: AnyObject {
    
    /// Function applies snapshot to diffable data source
    /// - Parameter data: <#data description#>
    func applySnapshot(data: [AllCountriesItemWrapper]?)
    
    /// Variable stores data for the displayed cells
    var mergeResults: [AllCountriesItemWrapper] {get set}
    
}

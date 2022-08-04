//
//  AllCountriesDataForCharts+CoreDataProperties.swift
//  Stats
//
//  Created by max on 30.07.2022.
//
//

import Foundation
import CoreData


extension AllCountriesDataForCharts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllCountriesDataForCharts> {
        return NSFetchRequest<AllCountriesDataForCharts>(entityName: "AllCountriesDataForCharts")
    }

    @NSManaged public var chartData: [StatisticsAllCountriesForChart]?
    @NSManaged public var date: String?

}

extension AllCountriesDataForCharts : Identifiable {

}

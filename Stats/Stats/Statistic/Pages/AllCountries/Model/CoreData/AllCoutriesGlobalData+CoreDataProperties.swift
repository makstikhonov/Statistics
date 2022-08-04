//
//  AllCoutriesGlobalData+CoreDataProperties.swift
//  Stats
//
//  Created by max on 30.07.2022.
//
//

import Foundation
import CoreData


extension AllCoutriesGlobalData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllCoutriesGlobalData> {
        return NSFetchRequest<AllCoutriesGlobalData>(entityName: "AllCoutriesGlobalData")
    }

    @NSManaged public var globalData: StatisticAllCountries?
    @NSManaged public var date: String?

}

extension AllCoutriesGlobalData : Identifiable {

}

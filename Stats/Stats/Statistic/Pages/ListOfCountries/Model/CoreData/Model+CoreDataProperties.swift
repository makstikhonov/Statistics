//
//  Model+CoreDataProperties.swift
//  Stats
//
//  Created by max on 27.07.2022.
//
//

import Foundation
import CoreData


extension Model {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "Model")
    }

    @NSManaged public var country: Country?
    @NSManaged public var countryCode: String?

}

extension Model : Identifiable {

}

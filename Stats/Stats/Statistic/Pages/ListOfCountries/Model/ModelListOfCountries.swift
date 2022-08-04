//
//  ModelListOfCountries.swift
//  Stats
//
//  Created by max on 05.05.2022.
//

import Foundation
import CoreData
import UIKit


class StatisticListOfCountries: NSObject, Codable, NSSecureCoding{
    static var supportsSecureCoding = true
    
    var countries: [Country] = []
    var date: String = ""
    
    func encode(with coder: NSCoder) {
        coder.encode(countries, forKey: "Countries")
        coder.encode(date, forKey: "Date")
    }
    required init?(coder: NSCoder) {
        super.init()
        countries = coder.decodeObject(forKey: "Countries") as! [Country]
        date = coder.decodeObject(forKey: "Date") as! String
    }
    
    enum CodingKeys: String, CodingKey {
        case countries = "Countries"
        case date = "Date"
    }
}

public class Country: NSObject, Codable, NSSecureCoding {
    
    public static var supportsSecureCoding = true
    
    var country: String
    var countryCode: String
    var slug: String
    var newConfirmed: Int
    var totalConfirmed: Int
    var newDeaths: Int
    var totalDeaths: Int
    var newRecovered: Int
    var totalRecovered: Int
    var date: String
    var flag: Data?
    
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(country)
        return hasher.finalize()
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.country == rhs.country
    }
    
    public static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.country < rhs.country
    }
    
    init(country: String, countryCode: String, slug: String, newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int, date: String){
        self.country = country
        self.countryCode = countryCode
        self.slug = slug
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = totalDeaths
        self.totalRecovered = totalDeaths
        self.date = date
    }
    
    //used for Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(country, forKey: .country)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(slug, forKey: .slug)
        try container.encode(newConfirmed, forKey: .newConfirmed)
        try container.encode(totalConfirmed, forKey: .totalConfirmed)
        try container.encode(newDeaths, forKey: .newDeaths)
        try container.encode(totalDeaths, forKey: .totalDeaths)
        try container.encode(newRecovered, forKey: .newRecovered)
        try container.encode(date, forKey: .date)
    }
    
    //used for Codable
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decode(String.self, forKey: .country)
        countryCode = try values.decode(String.self, forKey: .countryCode)
        slug  = try values.decode(String.self, forKey: .slug)
        totalConfirmed = try values.decode(Int.self, forKey: .totalConfirmed)
        newConfirmed = try values.decode(Int.self, forKey: .newConfirmed)
        newDeaths = try values.decode(Int.self, forKey: .newDeaths)
        totalDeaths = try values.decode(Int.self, forKey: .totalDeaths)
        newRecovered = try values.decode(Int.self, forKey: .newRecovered)
        totalRecovered = try values.decode(Int.self, forKey: .totalRecovered)
        date = try values.decode(String.self, forKey: .date)
    }
    
    //used for NSSecureCoding
    public func encode(with coder: NSCoder) {
        coder.encode(country, forKey: "Country")
        coder.encode(countryCode, forKey: "CountryCode")
        coder.encode(slug, forKey: "Slug")
        coder.encode(newConfirmed, forKey: "NewConfirmed")
        coder.encode(totalConfirmed, forKey: "TotalConfirmed")
        coder.encode(newDeaths, forKey: "NewDeaths")
        coder.encode(totalDeaths, forKey: "TotalDeaths")
        coder.encode(newRecovered, forKey: "NewRecovered")
        coder.encode(totalRecovered, forKey: "TotalRecovered")
        coder.encode(date, forKey: "Date")
        
    }
    
    //used for NSSecureCoding
    public required init?(coder: NSCoder) {
        //super.init()
        country = coder.decodeObject(of: NSString.self, forKey: "Country") as? String ?? ""
        countryCode = coder.decodeObject(of: NSString.self, forKey: "CountryCode") as? String ?? ""
        slug = coder.decodeObject(of: NSString.self, forKey: "Slug") as? String ?? ""
        newConfirmed = coder.decodeInteger(forKey: "NewConfirmed")
        totalConfirmed = coder.decodeInteger(forKey: "TotalConfirmed")
        newDeaths = coder.decodeInteger(forKey: "NewDeaths")
        totalDeaths = coder.decodeInteger(forKey: "TotalDeaths")
        newRecovered = coder.decodeInteger(forKey: "NewRecovered")
        totalRecovered = coder.decodeInteger(forKey: "TotalRecovered")
        date = coder.decodeObject(of: NSString.self, forKey: "Date") as? String ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths  = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}

@objc(CustomClassValueTransformer)
final class CustomClassValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName(rawValue: String(describing: CustomClassValueTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [Country.self, NSString.self, NSData.self, NSNumber.self ]
    }
    
    public static func register() {
        let transformer = CustomClassValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

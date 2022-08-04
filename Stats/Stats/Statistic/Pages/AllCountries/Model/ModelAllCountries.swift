//
//  Model.swift
//  Stats
//
//  Created by max on 04.05.2022.
//

import Foundation
import Charts
import UIKit

public class StatisticAllCountries: NSObject, Codable, NSSecureCoding{
    public static var supportsSecureCoding = true
    
    var global: Global
    var date: String
    
    init(global: Global, date: String) {
        self.global = global
        self.date = date
    }
    
    //used for Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(global, forKey: .global)
        try container.encode(date, forKey: .date)
    }
    
    //used for Codable
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        global = try values.decode(Global.self, forKey: .global)
        date = try values.decode(String.self, forKey: .date)
        
    }
    
    //used for NSSecureCoding
    public func encode(with coder: NSCoder) {
        coder.encode(global, forKey: "Global")
        coder.encode(date, forKey: "Date")
    }
    
    //used for NSSecureCoding
    public required init?(coder: NSCoder) {
        //super.init()
        global = coder.decodeObject(of: Global.self, forKey: "Global") ?? Global(newConfirmed: 0, totalConfirmed: 0, newDeaths: 0, totalDeaths: 0, newRecovered: 0, totalRecovered: 0)
        date = coder.decodeObject(of: NSString.self, forKey: "Date") as? String ?? ""
        
    }
    
    enum CodingKeys: String, CodingKey {
        case global = "Global"
        case date = "Date"
    }
}

public class Global: NSObject, Codable, NSSecureCoding {
    
    public static var supportsSecureCoding = true
    
    let newConfirmed: Int
    let totalConfirmed: Int
    let newDeaths: Int
    let totalDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    
    init(newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int){
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = totalDeaths
        self.totalRecovered = totalDeaths
    }
    
    //used for Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(newConfirmed, forKey: .newConfirmed)
        try container.encode(totalConfirmed, forKey: .totalConfirmed)
        try container.encode(newDeaths, forKey: .newDeaths)
        try container.encode(totalDeaths, forKey: .totalDeaths)
        try container.encode(newRecovered, forKey: .newRecovered)
    }
    
    //used for Codable
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalConfirmed = try values.decode(Int.self, forKey: .totalConfirmed)
        newConfirmed = try values.decode(Int.self, forKey: .newConfirmed)
        newDeaths = try values.decode(Int.self, forKey: .newDeaths)
        totalDeaths = try values.decode(Int.self, forKey: .totalDeaths)
        newRecovered = try values.decode(Int.self, forKey: .newRecovered)
        totalRecovered = try values.decode(Int.self, forKey: .totalRecovered)
    }
    
    //used for NSSecureCoding
    public func encode(with coder: NSCoder) {
        coder.encode(newConfirmed, forKey: "NewConfirmed")
        coder.encode(totalConfirmed, forKey: "TotalConfirmed")
        coder.encode(newDeaths, forKey: "NewDeaths")
        coder.encode(totalDeaths, forKey: "TotalDeaths")
        coder.encode(newRecovered, forKey: "NewRecovered")
        coder.encode(totalRecovered, forKey: "TotalRecovered")
        
    }
    
    //used for NSSecureCoding
    public required init?(coder: NSCoder) {
        //super.init()
        newConfirmed = coder.decodeInteger(forKey: "NewConfirmed")
        totalConfirmed = coder.decodeInteger(forKey: "TotalConfirmed")
        newDeaths = coder.decodeInteger(forKey: "NewDeaths")
        totalDeaths = coder.decodeInteger(forKey: "TotalDeaths")
        newRecovered = coder.decodeInteger(forKey: "NewRecovered")
        totalRecovered = coder.decodeInteger(forKey: "TotalRecovered")
    }
    
    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
    
    func formatDate(inputDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date: Date? = dateFormatter.date(from: inputDate)
        return date
    }
}

public class StatisticsAllCountriesForChart: NSObject, Codable, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    let newConfirmed: Int
    let totalConfirmed: Int
    let newDeaths: Int
    let totalDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    let date: String
    var formatedDate: Date?
    
    init(newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int, date: String){
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
        try container.encode(newConfirmed, forKey: .newConfirmed)
        try container.encode(totalConfirmed, forKey: .totalConfirmed)
        try container.encode(newDeaths, forKey: .newDeaths)
        try container.encode(totalDeaths, forKey: .totalDeaths)
        try container.encode(newRecovered, forKey: .newRecovered)
        try container.encode(totalRecovered, forKey: .totalRecovered)
        try container.encode(date, forKey: .date)
    }
    
    //used for Codable
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
        newConfirmed = coder.decodeInteger(forKey: "NewConfirmed")
        totalConfirmed = coder.decodeInteger(forKey: "TotalConfirmed")
        newDeaths = coder.decodeInteger(forKey: "NewDeaths")
        totalDeaths = coder.decodeInteger(forKey: "TotalDeaths")
        newRecovered = coder.decodeInteger(forKey: "NewRecovered")
        totalRecovered = coder.decodeInteger(forKey: "TotalRecovered")
        date = coder.decodeObject(of: NSString.self, forKey: "Date") as? String ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
    
    func formatDate(inputDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date: Date? = dateFormatter.date(from: inputDate)
        return date
    }
}

struct ChartItem: Hashable {
    let description: String
    let coords: [Coords]
    let section: AllCountriesSection = .charts
    
    func convert() -> [ChartDataEntry] {
        var chartData = [ChartDataEntry]()
        
        for item in coords{
            chartData.append(ChartDataEntry(x: item.x, y: item.y))
        }
        return chartData
    }
}

struct Coords: Codable, Hashable {
    let x: Double
    let y: Double
}

struct DataItem: Hashable {
    let quantity: Int
    let description: String
    let date: Date?
    let section: AllCountriesSection = .data
}

enum AllCountriesItemWrapper: Hashable {
    
    case charts(ChartItem)
    case data(DataItem)
}

enum AllCountriesSection: String, CaseIterable, Hashable {
    case charts = "Charts"
    case data = "Data"
}

@objc(AllCountriesGlobalDataClassValueTransformer)
final class AllCountriesGlobalDataClassValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName(rawValue: String(describing: AllCountriesGlobalDataClassValueTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [Global.self, NSString.self, NSNumber.self, StatisticAllCountries.self]
    }
    
    public static func register() {
        let transformer = AllCountriesGlobalDataClassValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

@objc(AllCountriesDataForChartsClassValueTransformer)
final class AllCountriesDataForChartsClassValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName(rawValue: String(describing: AllCountriesDataForChartsClassValueTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSString.self, NSNumber.self, StatisticsAllCountriesForChart.self, NSArray.self]
    }
    
    public static func register() {
        let transformer = AllCountriesDataForChartsClassValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

//
//  ModelMyFavouriteCountry.swift
//  Stats
//
//  Created by max on 01.08.2022.
//

import Foundation

class ModelMyFavouriteCountry {
    
}

enum MyFavouriteCountrySection: String, CaseIterable, Hashable {
    case info = "Country info"
    case map = "Map"
    case none
}

enum MyFavouriteCountryItemWrapper: Hashable {
    
    case info(InfoItem)
    case map(MapItem)
    case none
}

struct InfoItem: Hashable {
    let country: Country
    let section: MyFavouriteCountrySection = .info
}

struct MapItem: Hashable {
    let country: Country
    let section: MyFavouriteCountrySection = .map
}

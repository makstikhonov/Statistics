//
//  ListOfCountriesTestData.swift
//  Stats
//
//  Created by max on 02.08.2022.
//

import Foundation

/// class uses in tests
class ListOfCountriesTestData {

    let testObtainSummaryData: Data = {
            """
            {\"Global\":{\"NewConfirmed\":100282,\"TotalConfirmed\":1162857,\"NewDeaths\":5658,\"TotalDeaths\":63263,\"NewRecovered\":15405,\"TotalRecovered\":230845},\"Countries\":[{\"Country\":\"ALA Aland Islands\",\"CountryCode\":\"AX\",\"Slug\":\"ala-aland-islands\",\"NewConfirmed\":0,\"TotalConfirmed\":0,\"NewDeaths\":0,\"TotalDeaths\":0,\"NewRecovered\":0,\"TotalRecovered\":0,\"Date\":\"2020-04-05T06:37:00Z\"},{\"Country\":\"Afghanistan\",\"CountryCode\":\"AF\",\"Slug\":\"afghanistan\",\"NewConfirmed\":18,\"TotalConfirmed\":299,\"NewDeaths\":1,\"TotalDeaths\":7,\"NewRecovered\":0,\"TotalRecovered\":10,\"Date\":\"2020-04-05T06:37:00Z\"}],\"Date\":\"2020-04-05T06:37:00Z\"}
            """.data(using: String.Encoding.utf8)!
    }()
}

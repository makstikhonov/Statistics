//
//  ListOfCountriesNetworkManager.swift
//  Stats
//
//  Created by max on 03.08.2022.
//

import Foundation
import Moya

class NetworkManager <T: TargetType> {

    let dataProvider: MoyaProvider<T>
    
    init(stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub) {
        self.dataProvider = MoyaProvider<T>(stubClosure: stubClosure)
    }

    init(stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub, endpointClosure: @escaping MoyaProvider<T>.EndpointClosure) {
        self.dataProvider = MoyaProvider<T>(endpointClosure: endpointClosure, stubClosure: stubClosure)
    }
}

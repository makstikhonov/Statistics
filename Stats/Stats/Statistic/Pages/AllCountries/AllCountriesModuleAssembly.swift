//
//  AllCountriesModuleAssembly.swift
//  Stats
//
//  Created by max on 14.07.2022.
//

import Foundation
import UIKit

class AllCountriesModuleAssembly {
    
    func configureModule() -> AllCountriesCollectionViewController{
        
        let view = AllCountriesCollectionViewController()
        let presenter = AllCountriesPresenter()
        let dataManager = AllCountriesDataManagerImplementation()
        
        view.output = presenter
        presenter.view = view
        presenter.dataManager = dataManager
        
        return view
    }
}

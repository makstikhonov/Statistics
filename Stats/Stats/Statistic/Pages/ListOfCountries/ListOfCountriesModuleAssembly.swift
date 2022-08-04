//
//  ListOfCountriesModuleAssembly.swift
//  Stats
//
//  Created by max on 18.05.2022.
//

import Foundation
import UIKit

class ListOfCountriesModuleAssembly {

    private var delegate: ListOfCountriesViewControllerDelegate?
    
    init(delegate: ListOfCountriesViewControllerDelegate) {
        self.delegate = delegate;
    }
    
    func configureModule() -> ListOfCountriesViewController{
        
        let view = ListOfCountriesViewController()
        let presenter = ListOfCountriesPresenter()
        let dataManager = ListOfCountriesDataManagerImplementation()
        
        view.output = presenter
        view.delegate = self.delegate;
        presenter.view = view
        presenter.dataManager = dataManager
        
        return view
    }
}

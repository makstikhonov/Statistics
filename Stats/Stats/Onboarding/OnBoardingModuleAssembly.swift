//
//  OnBoardingModuleAssembly.swift
//  Stats
//
//  Created by max on 20.07.2022.
//

import Foundation
import UIKit


class OnBoardingModuleAssembly {
    
    func configureModule() -> OnBoardingViewController{
        
        let view = OnBoardingViewController()
        let presenter = OnBoardingPresenter()
        let dataManager = OnBoardingDataManagerImplementation()
        let statisticsController = StatisticViewController()
        
        view.output = presenter
        presenter.view = view
        presenter.appController = statisticsController
        presenter.dataManager = dataManager
        
        return view
    }
}

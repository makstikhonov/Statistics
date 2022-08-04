//
//  OnBoardingPresenter.swift
//  Stats
//
//  Created by max on 20.07.2022.
//

import Foundation
import PaperOnboarding
import UIKit

class OnBoardingPresenter: OnBoardingViewOutput {

    var dataManager: OnBoardingDataManagerImplementation!
    weak var view: OnBoardingViewInput!
    var appController: UIViewController!
    
    func obtainOnboardingData() -> [OnboardingItemInfo] {
        return dataManager.obtainOnboardingData()
    }
    
    func goToApp(){
        dataManager.onBoardingComplete()
        view.transitionToApp(to: appController)
    }
}

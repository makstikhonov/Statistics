//
//  OnBoardingViewOutput.swift
//  Stats
//
//  Created by max on 20.07.2022.
//

import Foundation
import PaperOnboarding

protocol OnBoardingViewOutput: AnyObject {
    
    func obtainOnboardingData() -> [OnboardingItemInfo]
    
    func goToApp()
    
}

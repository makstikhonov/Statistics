//
//  OnBoardingViewInput.swift
//  Stats
//
//  Created by max on 20.07.2022.
//

import Foundation
import PaperOnboarding
import UIKit

protocol OnBoardingViewInput: AnyObject {
    
    func fillOnboardingWithData() -> [OnboardingItemInfo]
    
    func transitionToApp(to controller: UIViewController)
}

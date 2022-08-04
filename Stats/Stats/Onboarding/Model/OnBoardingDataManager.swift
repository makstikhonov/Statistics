//
//  OnBoardingDataManager.swift
//  Stats
//
//  Created by max on 19.07.2022.
//

import Foundation
import PaperOnboarding
import UIKit

protocol OnBoardingDataManager {
    func obtainOnboardingData() -> [OnboardingItemInfo]
    func onBoardingComplete()
}

class OnBoardingDataManagerImplementation: OnBoardingDataManager {

    func obtainOnboardingData() -> [OnboardingItemInfo] {

       return [
         OnboardingItemInfo(informationImage: UIImage(named: "1") ?? UIImage(),
                                       title: "",
                                 description: "",
                            pageIcon: UIImage(systemName: "1.circle") ?? UIImage(),
                                       color: UIColor.white,
                                  titleColor: UIColor.systemGray6,
                            descriptionColor: UIColor.systemGray6,
                                   titleFont: UIFont.systemFont(ofSize: 12),
                            descriptionFont: UIFont.systemFont(ofSize: 12)),

         OnboardingItemInfo(informationImage: UIImage(named: "2") ?? UIImage(),
                                       title: "",
                                 description: "",
                            pageIcon: UIImage(systemName: "2.circle") ?? UIImage(),
                                       color: UIColor.white,
                                  titleColor: UIColor.systemGray6,
                            descriptionColor: UIColor.systemGray6,
                                   titleFont: UIFont.systemFont(ofSize: 12),
                            descriptionFont: UIFont.systemFont(ofSize: 12)),

         OnboardingItemInfo(informationImage: UIImage(named: "3") ?? UIImage(),
                                       title: "",
                                 description: "",
                            pageIcon: UIImage(systemName: "3.circle") ?? UIImage(),
                                       color: UIColor.white,
                                  titleColor: UIColor.systemGray6,
                            descriptionColor: UIColor.systemGray6,
                                   titleFont: UIFont.systemFont(ofSize: 12),
                            descriptionFont: UIFont.systemFont(ofSize: 12))
         ]
     }
    
    func onBoardingComplete(){
        let userDefaults = UserDefaults.standard
    
        userDefaults.set(true, forKey: Metrics.userDefaultsKey)
    }
}

extension OnBoardingDataManagerImplementation {
    enum Metrics {
        static let userDefaultsKey: String = "OnboardingComplete"
    }
}

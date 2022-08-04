//
//  OnBoardingViewController.swift
//  Stats
//
//  Created by max on 15.07.2022.
//

import Foundation
import UIKit
import PaperOnboarding

class OnBoardingViewController: UIViewController, OnBoardingViewDelegate, OnBoardingViewInput {
    
    var output: OnBoardingViewOutput!
    let onBoardingView = OnBoardingView()
    var onBoardingData: [OnboardingItemInfo] = []
    
    override func loadView() {
        onBoardingView.delegate = self
        view = onBoardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onBoardingData = fillOnboardingWithData()
        
        onBoardingView.onboarding.delegate = self
        onBoardingView.onboarding.dataSource = self
    }
    
    func fillOnboardingWithData() -> [OnboardingItemInfo]{
        return output.obtainOnboardingData()
    }
    
    func goToApp(){
        output.goToApp()
    }
    
    func didPressedSkipButton() {
        goToApp()
    }
    
    func transitionToApp(to controller: UIViewController) {
        guard let window = view.window else { return }
        
        window.rootViewController = controller
        UIView.transition(with: window, duration: Metric.transitionDuration, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }
}

extension OnBoardingViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onBoardingData[index]
    }
    
    func onboardingItemsCount() -> Int {
        return onBoardingData.count
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        if index == onBoardingData.count - 1 {
            onBoardingView.skipButton.setTitle(Metric.skipButtonStartTitleLabel, for: .normal)
        } else {
            onBoardingView.skipButton.setTitle(Metric.skipButtonSkipTitleLabel, for: .normal)
        }
        
        item.backgroundColor = Metric.itemBackgroundColor
        
        if let imageSize = item.imageView?.image?.size {
            item.informationImageWidthConstraint?.constant = imageSize.width
            item.informationImageHeightConstraint?.constant = imageSize.height
            item.setNeedsUpdateConstraints()
        }
    }
    
    func onboardingWillTransitonToLeaving() {
        goToApp()
    }
}

extension OnBoardingViewController {
    enum Metric {
        static let skipButtonStartTitleLabel: String = "Start"
        static let skipButtonSkipTitleLabel: String = "Skip"
        static let transitionDuration: Double = 0.5
        static let itemBackgroundColor: UIColor = .white
    }
}

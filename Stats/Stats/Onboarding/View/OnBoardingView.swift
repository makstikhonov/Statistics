//
//  OnBoardingView.swift
//  Stats
//
//  Created by max on 19.07.2022.
//

import UIKit
import PaperOnboarding

protocol OnBoardingViewDelegate: AnyObject {
    func didPressedSkipButton()
}

class OnBoardingView: UIView {
    
    let onboarding = PaperOnboarding()
    weak var delegate: OnBoardingViewDelegate?
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(Metric.skipButtonTitile, for: .normal)
        button.addTarget(self, action: #selector(goToAppButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        
        addSubview(onboarding)
        onboarding.edgesToSuperview()
        
        addSubview(skipButton)
        bringSubviewToFront(skipButton)
        skipButton.width(Metric.skipButtonWidth)
        skipButton.centerXToSuperview()
        skipButton.bottom(to: self, self.bottomAnchor, offset: Metric.skipButtonBottomOffset)
    }
    
    @objc
    func goToAppButtonPressed(){
        delegate?.didPressedSkipButton()
    }
}

extension OnBoardingView {
    enum Metric {
        static let skipButtonTitile: String = "Skip"
        static let skipButtonWidth: CGFloat = 100
        static let skipButtonBottomOffset: CGFloat = -100
    }
}

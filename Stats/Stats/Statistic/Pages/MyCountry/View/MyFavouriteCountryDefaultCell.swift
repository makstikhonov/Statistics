//
//  MyFavouriteCountryDefaultCell.swift
//  Stats
//
//  Created by max on 11.07.2022.
//

import Foundation
import UIKit

class MyFavouriteCountryDefaultCell: UICollectionViewCell{
    
    lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        view.backgroundColor = RoundedView.backgroundColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TitleLabel.defaultText
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(roundedView)
        roundedView.edgesToSuperview()
        
        addSubview(button)
        button.edgesToSuperview()
        
        addSubview(titleLabel)
        titleLabel.centerInSuperview()
    }
}

extension MyFavouriteCountryDefaultCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
    }
    
    enum TitleLabel {
        static let defaultText: String = "Select a country from the list"
    }
    
}

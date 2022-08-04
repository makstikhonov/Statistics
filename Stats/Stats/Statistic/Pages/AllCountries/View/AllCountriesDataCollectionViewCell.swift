//
//  UICollectionViewCell.swift
//  Stats
//
//  Created by max on 04.05.2022.
//

import UIKit
import TinyConstraints
import Foundation


class AllCountriesDataCollectionViewCell: UICollectionViewCell{
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        view.backgroundColor = RoundedView.backgroundColor
        return view
    }()
    
    private  lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        return label
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
        
        addSubview(titleLabel)
        titleLabel.left(to: contentView, contentView.leftAnchor, offset: TitleLabel.leftOffset)
        titleLabel.top(to: contentView, contentView.topAnchor, offset: TitleLabel.topOffset)
        
        addSubview(numberLabel)
        numberLabel.right(to: contentView, contentView.rightAnchor, offset: NumberLabel.rightOffset)
        numberLabel.bottom(to: contentView, contentView.bottomAnchor, offset: NumberLabel.bottomOffset)
        
    }
    
    func configure(with data: DataItem) {
        titleLabel.text = data.description
        numberLabel.text = String(data.quantity.withCommas())
    }
    
}

extension AllCountriesDataCollectionViewCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
    }
    
    enum TitleLabel {
        static let leftOffset: CGFloat = 20
        static let topOffset: CGFloat = 20
    }
    
    enum NumberLabel {
        static let rightOffset: CGFloat = -20
        static let bottomOffset: CGFloat = -20
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

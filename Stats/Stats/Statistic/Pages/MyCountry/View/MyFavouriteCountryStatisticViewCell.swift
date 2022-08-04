//
//  MyFavouriteCountryStatisticViewCell.swift
//  Stats
//
//  Created by max on 11.07.2022.
//

import Foundation
import UIKit

class MyFavouriteCountryStatisticViewCell: UICollectionViewCell{
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        view.backgroundColor = RoundedView.backgroundColor
        return view
    }()
    
    private  lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var informationLabel: UILabel = {

        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .standard
        label.numberOfLines = 0
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
        
        addSubview(countryNameLabel)
        countryNameLabel.left(to: contentView, contentView.leftAnchor, offset: CountryNameLabel.leftOffset)
        countryNameLabel.top(to: contentView, contentView.topAnchor, offset: CountryNameLabel.topOffset)
        
        addSubview(informationLabel)
        informationLabel.top(to: countryNameLabel, countryNameLabel.topAnchor, offset: InformationLabel.topOffset)
        informationLabel.left(to: contentView, contentView.leftAnchor, offset: InformationLabel.leftOffset)
    }
    
    func configure(with data: Country) {
        countryNameLabel.text = "Country: \(data.country)"
        informationLabel.text = """
New confirmed: \(data.newConfirmed.withCommas())
Total confirmed: \(data.totalConfirmed.withCommas())
New deaths: \(data.newDeaths.withCommas())
Total deaths: \(data.totalDeaths.withCommas())
New recovered: \(data.newRecovered.withCommas())
Total recovered: \(data.totalRecovered.withCommas())
Date: \(formatDate(inputDate: data.date))
"""
    }
    
    func formatDate(inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y/MM/dd"
        let date: Date? = dateFormatter.date(from: inputDate)
        return dateFormatter.string(from: date ?? Date())
    }
}

extension MyFavouriteCountryStatisticViewCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
    }
    
    enum CountryNameLabel {
        static let leftOffset: CGFloat = 20
        static let topOffset: CGFloat = 20
    }
    
    enum InformationLabel {
        static let leftOffset: CGFloat = 20
        static let topOffset: CGFloat = 20
    }
}

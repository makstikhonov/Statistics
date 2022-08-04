//
//  ListOfCountriesCollectionViewCell.swift
//  Stats
//
//  Created by max on 05.05.2022.
//

import Foundation

import UIKit
import TinyConstraints

class ListOfCountriesCollectionViewCell: UICollectionViewCell{
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        view.backgroundColor = RoundedView.backgroundColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage()
        let icon = UIImageView(image: image)
        icon.contentMode = .scaleAspectFit
    
        return icon
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
            let aiv = UIActivityIndicatorView()
            aiv.startAnimating()
            return aiv
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
        titleLabel.centerY(to: contentView)
        imageView.frame = CGRect(x: 0, y: 0, width: ImageView.width, height: ImageView.height)
        
        addSubview(imageView)
        imageView.rightToSuperview(offset: ImageView.rightOffset)
        imageView.centerYToSuperview()
        imageView.height(ImageView.height)
        imageView.width(ImageView.width)
        
        addSubview(activityIndicatorView)
        activityIndicatorView.rightToSuperview(offset: IndicatorView.rightOffset)
        activityIndicatorView.centerYToSuperview()
        activityIndicatorView.height(IndicatorView.height)
        activityIndicatorView.width(IndicatorView.width)

    }
    override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = UIImage()
            activityIndicatorView.startAnimating()
        }
    
    func configure(with data: Country) {
        titleLabel.text = data.country
    
        if data.flag != nil {
            imageView.image = UIImage(data: data.flag ?? Data())
            activityIndicatorView.stopAnimating()
        }
    }
}
extension ListOfCountriesCollectionViewCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
    }
    
    enum TitleLabel {
        static let leftOffset: CGFloat = 20
    }
    
    enum ImageView {
        static let width: CGFloat = 50
        static let height: CGFloat = 50
        static let rightOffset: CGFloat = -20
    }
    
    enum IndicatorView {
        static let width: CGFloat = 50
        static let height: CGFloat = 50
        static let rightOffset: CGFloat = -20
    }
}

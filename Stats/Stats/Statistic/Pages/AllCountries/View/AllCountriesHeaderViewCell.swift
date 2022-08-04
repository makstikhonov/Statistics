//
//  AllCountriesCollectionViewCell.swift
//  Stats
//
//  Created by max on 30.07.2022.
//

import Foundation
import UIKit
import TinyConstraints

class AllCountriesHeaderViewCell: UICollectionReusableView {
    
    public var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(){
        addSubview(textLabel)
        textLabel.left(to: self, self.leftAnchor, offset: 20)
        textLabel.centerY(to: self)
    }
    
    func configure(with text: String) {
        textLabel.text = text
    }
}

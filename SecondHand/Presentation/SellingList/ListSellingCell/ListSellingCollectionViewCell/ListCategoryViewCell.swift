//
//  ListCategoryViewCell.swift
//  SecondHand
//
//  Created by Daffashiddiq on 21/07/22.
//

import UIKit

final class ListCategoryViewCell: UICollectionViewCell {
    
    var categoryView = UIView()
    var searchImageView = UIImageView()
    var categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItemValue(name nama: String, image img: String) {
        self.categoryLabel.text = nama
        self.searchImageView.image = UIImage(named: img)
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func defineLayout() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(searchImageView, categoryLabel)
        contentView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = .label
        searchImageView.clipsToBounds = true
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            searchImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalToConstant: 20),
            searchImageView.widthAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func selectedState() {
        contentView.backgroundColor = UIColor(rgb: 0x7126B5)
        categoryLabel.textColor = .white
        searchImageView.tintColor = .white
    }
    
    func deselectedState() {
        contentView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        categoryLabel.textColor = .black
        searchImageView.tintColor = .black
    }
    
}

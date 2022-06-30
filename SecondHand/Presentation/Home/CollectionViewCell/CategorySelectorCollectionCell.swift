//
//  CategorySelectorCollectionCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class CategorySelectorCollectionCell: UICollectionViewCell {
    
    var categoryView = UIView()
    var searchImageView = UIImageView()
    var categoryLabel = UILabel()
    
    typealias OnCellTap = () -> Void
    var onCellTap: OnCellTap?
    var isCellSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = UIColor(rgb: 0xE2D4F0)
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
    
    private func defineLayout() {
        contentView.addSubviews(searchImageView, categoryLabel)
        contentView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapRecognizer)
        
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = .label
        searchImageView.clipsToBounds = true
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.numberOfLines = 1
        categoryLabel.setTitle(text: "Text Test Text Test", size: 14, weight: .regular)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            searchImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalToConstant: 20),
            searchImageView.widthAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
    @objc private func onCellTapped() {
        isCellSelected.toggle()
        onCellTap?()
    }
    
}


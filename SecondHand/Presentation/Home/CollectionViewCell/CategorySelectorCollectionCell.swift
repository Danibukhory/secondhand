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
        categoryView.backgroundColor = UIColor(rgb: 0xE2D4F0)
    }
    
    private func defineLayout() {
        contentView.addSubview(categoryView)
        categoryView.addSubview(searchImageView)
        categoryView.addSubview(categoryLabel)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapRecognizer)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 12
        categoryView.backgroundColor = UIColor(rgb: 0xE2D4f0)
        
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = .label
        searchImageView.clipsToBounds = true
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.numberOfLines = 1
        categoryLabel.setTitle(text: "Text Test", size: 14, weight: .regular)
        
        NSLayoutConstraint.activate([
            categoryView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor),
            categoryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            searchImageView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 10),
            searchImageView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalToConstant: 20),
            searchImageView.widthAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -10),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
    @objc private func onCellTapped() {
        isCellSelected.toggle()
        onCellTap?()
    }
    
}


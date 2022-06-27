//
//  CategoriesRowCollectionViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 26/06/22.
//

import UIKit

final class CategoriesRowCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "ct-cv-row-cell"
    
    public lazy var categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    public lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(categoryView)

        
        categoryView.addSubviews(
            categoryImageView,
            categoryLabel
        )
        
            
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor),
            categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryImageView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 20),
            categoryImageView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 20),
            categoryImageView.widthAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 10),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
        ])
    }

//    @objc private func onCellTapped() {
//        debugPrint("clicked")
//    }
}

//
//  SellingProductCollectionViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 26/06/22.
//

import UIKit

final class SellingProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "sp-cv-cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
}

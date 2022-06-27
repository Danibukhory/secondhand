//
//  AddProductTableViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 26/06/22.
//

import UIKit

final class AddProductTableViewCell: UITableViewCell { // change to collectionview cell later
    
    static let identifier = "ad-tb-cell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 156,height: 206)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(AddProductCollectionViewCell.self, forCellWithReuseIdentifier: AddProductCollectionViewCell.identifier)
        collectionView.register(SellingProductCollectionViewCell.self,forCellWithReuseIdentifier: SellingProductCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
        ])
       
        
    }
}

extension AddProductTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViewCell.identifier, for: indexPath) as? AddProductCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        return cell
        
//        if indexPath.row == 0 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViewCell.identifier, for: indexPath) as? AddProductCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SellingProductCollectionViewCell.identifier, for: indexPath) as? SellingProductCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            return cell
//        }
    }
    
}



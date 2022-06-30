//
//  HomeProductCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class HomeProductCell: UITableViewCell {
    
    var collectionView: UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    private let screenRect: CGRect = UIScreen.main.bounds
    var products: [SHBuyerProductResponse] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: 16)
        collectionView = UICollectionView(layout: flowLayout)
        collectionView?.register(HomeProductCollectionCell.self, forCellWithReuseIdentifier: "\(HomeProductCollectionCell.self)")
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.isScrollEnabled = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        contentView.addSubview(collectionView!)
        
        NSLayoutConstraint.activate([
            collectionView!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            collectionView!.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            collectionView!.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 920),
        ])
        
    }
}

extension HomeProductCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(HomeProductCollectionCell.self)",
            for: indexPath
        ) as? HomeProductCollectionCell else {
            return UICollectionViewCell()
        }
        cell.fill(with: products[item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        let height: CGFloat = 206
        
        let screenWidth: CGFloat = screenRect.width
        width = (screenWidth - 48) / 2
        
        return CGSize(width: width, height: height)
    }
    
    
}



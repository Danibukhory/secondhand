//
//  HomeProductCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class HomeProductCell: UITableViewCell {
    
    typealias OnProductLoad = () -> Void
    var onProductLoad: OnProductLoad?
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HomeProductCollectionCell.self, forCellWithReuseIdentifier: "\(HomeProductCollectionCell.self)")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let screenRect: CGRect = UIScreen.main.bounds
    var products: [SHBuyerProductResponse] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadProducts()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    private func loadProducts() {
        let api = SecondHandAPI()
        let group = DispatchGroup()
        defer {
            group.notify(queue: .main) { [weak self] in
                guard let _self = self else { return }
                let numberOfItems = _self.products.count
                if numberOfItems % 2 != 0 {
                    let rows = (numberOfItems + 1) / 2
                    _self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat((206 + 16) * rows) + 16).isActive = true
                } else {
                    let rows = numberOfItems / 2
                    _self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat((206 + 16) * rows) + 16).isActive = true
                }
                _self.collectionView.reloadData()
                _self.onProductLoad?()
            }
        }
        group.enter()
        api.getBuyerProducts { [weak self] result, error in
            guard let _self = self else { return }
            _self.products = result ?? []
            group.leave()
        }
    }
}

extension HomeProductCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var width: CGFloat = 0
        let height: CGFloat = 206
        let screenWidth: CGFloat = screenRect.width
        width = (screenWidth - 48) / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        print("pressed item \(item)")
    }
    
    
}



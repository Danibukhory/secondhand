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
    
    typealias DidSelectProduct = (SHBuyerProductResponse) -> Void
    var didSelectProduct: DidSelectProduct?
    
    var sorterButton: SHButton = {
        let button = SHButton(
            frame: .zero,
            title: "Urutkan berdasarkan: acak",
            type: .bordered,
            size: .small
        )
        button.alpha = 0
        button.showsMenuAsPrimaryAction = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HomeProductCollectionCell.self, forCellWithReuseIdentifier: "\(HomeProductCollectionCell.self)")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.color = UIColor(rgb: 0x7126B5)
        return indicator
    }()
    
    var isSorterButtonShown: Bool = false {
        didSet {
            if isSorterButtonShown {
                heightSorterButtonConstraint?.constant = 48
                contentView.layoutIfNeeded()
            } else {
                heightSorterButtonConstraint?.constant = 0
                contentView.layoutIfNeeded()
            }
        }
    }
    var isSorterButtonInitiallyShown: Bool = UserDefaults.standard.bool(forKey: "isHomeProductSorterShown")
    
    var heightSorterButtonConstraint: NSLayoutConstraint?
    
    private let screenRect: CGRect = UIScreen.main.bounds
    var products: [SHBuyerProductResponse] = []
    var displayedProducts: [SHBuyerProductResponse] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadProducts()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(collectionView, loadingIndicator, sorterButton)
        collectionView.dataSource = self
        collectionView.delegate = self
        sorterButton.menu = UIMenu(
            title: "Urutkan berdasarkan",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: self.sortMenuElements()
        )
        if isSorterButtonInitiallyShown {
            heightSorterButtonConstraint = sorterButton.heightAnchor.constraint(equalToConstant: 48)
        } else {
            heightSorterButtonConstraint = sorterButton.heightAnchor.constraint(equalToConstant: 0)
        }
        
        NSLayoutConstraint.activate([
            sorterButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            sorterButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            heightSorterButtonConstraint!,
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: sorterButton.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
        ])
    }
    
    func loadProducts() {
        let api = SecondHandAPI.shared
        let group = DispatchGroup()
        defer {
            group.notify(queue: .main) { [weak self] in
                guard let _self = self else { return }
                _self.collectionView.reloadData()
                _self.onProductLoad?()
            }
        }
        group.enter()
        api.getBuyerProducts { [weak self] result, error in
            guard let _self = self else { return }
            _self.products = result ?? []
            _self.displayedProducts = _self.products
            group.leave()
        }
    }
    
    private func sortMenuElements() -> [UIMenuElement] {
        var menus: [UIMenuElement] = []
        
        let sortByNameAscending = UIAction(
            title: "Nama (A - Z)",
            image: UIImage(systemName: "a.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.sorterButton.setActiveButtonTitle(string: "Nama (A - Z)")
            _self.sorterButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
            _self.displayedProducts.sort(by: { ($0.name) < ($1.name) })
            _self.collectionView.reloadData()
        }
        let sortByNameDescending = UIAction(
            title: "Nama (Z - A)",
            image: UIImage(systemName: "z.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.sorterButton.setActiveButtonTitle(string: "Nama (Z - A)")
            _self.sorterButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
            _self.displayedProducts.sort(by: { ($0.name) > ($1.name) })
            _self.collectionView.reloadData()
        }
        let sortByPriceAscending = UIAction(
            title: "Harga (rendah ke tinggi)",
            image: UIImage(systemName: "0.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.sorterButton.setActiveButtonTitle(string: "Harga (rendah ke tinggi)")
            _self.sorterButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
            _self.displayedProducts.sort(by: { ($0.basePrice) < ($1.basePrice) })
            _self.collectionView.reloadData()
        }
        let sortByPriceDescending = UIAction(
            title: "Harga (tinggi ke rendah)",
            image: UIImage(systemName: "9.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.sorterButton.setActiveButtonTitle(string: "Harga (tinggi ke rendah)")
            _self.sorterButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
            _self.displayedProducts.sort(by: { ($0.basePrice) > ($1.basePrice) })
            _self.collectionView.reloadData()
        }
        let random = UIAction(
            title: "Acak",
            image: UIImage(systemName: "arrow.triangle.swap"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.sorterButton.setActiveButtonTitle(string: "Acak")
            _self.sorterButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
            _self.displayedProducts.shuffle()
            _self.collectionView.reloadData()
        }
        menus.append(sortByNameAscending)
        menus.append(sortByNameDescending)
        menus.append(sortByPriceAscending)
        menus.append(sortByPriceDescending)
        menus.append(random)
        
        return menus
    }
}

extension HomeProductCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return displayedProducts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = indexPath.item
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(HomeProductCollectionCell.self)",
            for: indexPath
        ) as? HomeProductCollectionCell else {
            return UICollectionViewCell()
        }
        cell.fill(with: displayedProducts[item])
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let item = indexPath.item
        print("pressed item \(item)")
        
        let product = displayedProducts[item]
        didSelectProduct?(product)
    }
    
}



//
//  HomeHeaderCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class HomeHeaderCell: UITableViewCell, UITextFieldDelegate {
    
    var searchBar = SHRoundedTextfield()
    var promoLabel = UILabel()
    var discountLabel = UILabel()
    var discountValueLabel = UILabel()
    var promoImageView = UIImageView()
    var gradientLayer = CAGradientLayer()
    var collectionLabel = UILabel()
    var collectionView: UICollectionView?
    var flowLayout = CategorySelectorFlowLayout()
    var searchImageView: UIImageView = {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchImageView = UIImageView(image: searchImage)
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = UIColor(rgb: 0x8A8A8A)
        searchImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchImageView.widthAnchor.constraint(equalTo: searchImageView.heightAnchor).isActive = true
        return searchImageView
    }()
    
    typealias OnSearchBarTap = () -> Void
    var onSearchBarTap: OnSearchBarTap?
    
    typealias OnDismissButtonTap = () -> Void
    var onDismissButtonTap: OnDismissButtonTap?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGradient()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient() {
        gradientLayer.type = .axial
        gradientLayer.colors = [UIColor(rgb: 0xFFE9C9).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.5, 1]
        
        contentView.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.contentView.bounds
    }
    
    func defineLayout() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubview(searchBar)
        contentView.addSubview(promoLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(discountValueLabel)
        contentView.addSubview(promoImageView)
        contentView.addSubview(collectionLabel)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Cari di SecondHand"
        searchBar.rightView = searchImageView
        searchBar.rightViewMode = .unlessEditing
        searchBar.delegate = self
        
        promoLabel.translatesAutoresizingMaskIntoConstraints = false
        promoLabel.setTitle(text: "Bulan Ramadhan\nBanyak Diskon!", size: 20, weight: .bold)
        promoLabel.numberOfLines = 2
        
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.setTitle(text: "Diskon hingga", size: 14, weight: .regular)
        
        discountValueLabel.translatesAutoresizingMaskIntoConstraints = false
        discountValueLabel.setTitle(text: "60%", size: 20, weight: .medium, color: UIColor(rgb: 0xFA2C5A))
        
        promoImageView.translatesAutoresizingMaskIntoConstraints = false
        promoImageView.image = UIImage(named: "img-home-gift")
        
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionLabel.setTitle(text: "Telusuri Kategori", size: 14, weight: .medium)

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(layout: flowLayout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .clear
        collectionView?.register(CategorySelectorCollectionCell.self, forCellWithReuseIdentifier: "\(CategorySelectorCollectionCell.self)")
        contentView.addSubview(collectionView!)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: margin.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: margin.widthAnchor),
            searchBar.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            
            promoLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            promoLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            discountLabel.topAnchor.constraint(equalTo: promoLabel.bottomAnchor, constant: 10),
            discountLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            discountValueLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor),
            discountValueLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            promoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            promoImageView.topAnchor.constraint(equalTo: promoLabel.topAnchor),
            
            collectionLabel.topAnchor.constraint(equalTo: promoImageView.bottomAnchor, constant: 20),
            collectionLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            collectionView!.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            collectionView!.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView!.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 10),
            collectionView!.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            collectionView!.heightAnchor.constraint(equalToConstant: 40),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
    }
    
    @objc private func dismissView() {
        onDismissButtonTap?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.tintColor = .secondaryLabel
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dismissButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        textField.rightView = dismissButton
        onSearchBarTap?()
    }
    
}

extension HomeHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategorySelectorCollectionCell.self)", for: indexPath) as? CategorySelectorCollectionCell else { return }
        cell.categoryView.backgroundColor = UIColor(rgb: 0x7126B5)
        cell.categoryLabel.textColor = .systemBackground
        cell.searchImageView.tintColor = .systemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategorySelectorCollectionCell.self)", for: indexPath) as? CategorySelectorCollectionCell else { return }
        cell.categoryView.backgroundColor = UIColor(rgb: 0xE2D4f0)
        cell.categoryLabel.textColor = .label
        cell.searchImageView.tintColor = .label
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 50
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CategorySelectorCollectionCell.self)",
            for: indexPath
        ) as? CategorySelectorCollectionCell else {
            return UICollectionViewCell()
        }
//        self.flowLayout.itemSize = CGSize(width: cell.frame.width, height: 50)
        cell.onCellTap = {
            if cell.isCellSelected {
                cell.categoryView.backgroundColor = UIColor(rgb: 0x7126B5)
                cell.searchImageView.tintColor = .systemBackground
                cell.categoryLabel.textColor = .systemBackground
            } else {
                cell.categoryView.backgroundColor = UIColor(rgb: 0xE2D4F0)
                cell.searchImageView.tintColor = .label
                cell.categoryLabel.textColor = .label
            }
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategorySelectorCollectionCell else {
                return CGSize(width: 120, height: 44)
            }
//            let cellWidth: CGFloat = 120
//            let cellHeight: CGFloat = 44
//            let size = CGSize(width: cellWidth, height: cellHeight)
            return CGSize(width: cell.frame.width, height: cell.frame.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView
        , layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}


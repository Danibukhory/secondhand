//
//  HomeHeaderCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit
import ColorKit

final class HomeHeaderCell: UITableViewCell, UITextFieldDelegate {
    
    var searchBar = SHRoundedTextfield()
    var promoLabel = UILabel()
    var discountLabel = UILabel()
    var discountValueLabel = UILabel()
    var promoImageView = UIImageView()
    var gradientLayer = CAGradientLayer()
    var collectionLabel = UILabel()
    var api = SecondHandAPI.shared
    var categoryCollectionView: UICollectionView!
    var backgroundTopColor: CGColor = UIColor(rgb: 0xFFE9C9).cgColor
    var categoryFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        return flowLayout
    }()
    var searchImageView: UIImageView = {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchImageView = UIImageView(image: searchImage)
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.tintColor = UIColor(rgb: 0x8A8A8A)
        searchImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchImageView.widthAnchor.constraint(equalTo: searchImageView.heightAnchor).isActive = true
        return searchImageView
    }()
    var categoryLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    var bannerLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    var bannerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var bannerPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = .clear
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    var banners: [SHBannerResponse] = []
    var selectorCategories: [SHCategoryResponse] = []
    
    typealias OnSearchBarTap = () -> Void
    var onSearchBarTap: OnSearchBarTap?
    
    typealias OnDismissButtonTap = () -> Void
    var onDismissButtonTap: OnDismissButtonTap?
    
    typealias OnCategorySelectorLoad = () -> Void
    var onCategorySelectorLoad: OnCategorySelectorLoad?
    
    typealias OnCategorySelectorTap = (SHCategoryResponse) -> Void
    var onCategorySelectorTap: OnCategorySelectorTap?
    
    typealias OnSearchBarTextChange = (String) -> Void
    var onSearchBarTextChange: OnSearchBarTextChange?
    
    typealias NewTableViewColor = (UIColor) -> Void
    var newTableViewColor: NewTableViewColor?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGradient()
        setupCollectionViews()
        loadCategories()
        loadBanners()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient() {
        gradientLayer.type = .axial
        gradientLayer.colors = [backgroundTopColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.4, 1]
        
        contentView.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.contentView.bounds
    }
    
    func defineLayout() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(searchBar, promoLabel, discountLabel, discountValueLabel, promoImageView, collectionLabel, categoryLoadingIndicator, bannerLoadingIndicator)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Cari di SecondHand"
        searchBar.rightView = searchImageView
        searchBar.rightViewMode = .unlessEditing
        searchBar.addTarget(self, action: #selector(handleSearchBarTextChange), for: .editingChanged)
        searchBar.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.returnKeyType = .done
        
        promoLabel.translatesAutoresizingMaskIntoConstraints = false
        promoLabel.setTitle(text: "Bulan Ramadhan\nBanyak Diskon!", size: 20, weight: .bold)
        promoLabel.numberOfLines = 2
        promoLabel.alpha = 0
        
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.setTitle(text: "Diskon hingga", size: 14, weight: .regular)
        discountLabel.alpha = 0
        
        discountValueLabel.translatesAutoresizingMaskIntoConstraints = false
        discountValueLabel.setTitle(text: "60%", size: 20, weight: .medium, color: UIColor(rgb: 0xFA2C5A))
        discountValueLabel.alpha = 0
        
        promoImageView.translatesAutoresizingMaskIntoConstraints = false
        promoImageView.image = UIImage(named: "img-home-gift")
        promoImageView.alpha = 0
        
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionLabel.setTitle(text: "Telusuri Kategori", size: 14, weight: .medium)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: margin.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: margin.widthAnchor),
            searchBar.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            
            bannerCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            bannerCollectionView.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            bannerCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 150),
            
            bannerLoadingIndicator.centerXAnchor.constraint(equalTo: bannerCollectionView.centerXAnchor),
            bannerLoadingIndicator.centerYAnchor.constraint(equalTo: bannerCollectionView.centerYAnchor),
            
            bannerPageControl.bottomAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: -8),
            bannerPageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
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
            
            categoryCollectionView.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            categoryCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 10),
            categoryCollectionView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryLoadingIndicator.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 10),
            categoryLoadingIndicator.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            
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
    
    @objc private func handleSearchBarTextChange() {
        guard let text = searchBar.text
        else { return }
        onSearchBarTextChange?(text)
    }
    
    func loadCategories() {
        api.getProductCategories { [weak self] result, error in
            guard let _self = self else { return }
            _self.categoryCollectionView.alpha = 0
            let allCategory = SHCategoryResponse(id: nil, name: "Semua")
            _self.selectorCategories = result ?? []
            _self.selectorCategories.insert(allCategory, at: 0)
            _self.categoryCollectionView.reloadData()
            _self.onCategorySelectorLoad?()
        }
    }
    
    func loadBanners() {
        api.getBanners { [weak self] result, error in
            guard let _self = self,
                  let _result = result
            else { return }
            _self.bannerCollectionView.alpha = 0
            _self.banners = _result
            _self.bannerCollectionView.reloadData()
            _self.bannerPageControl.numberOfPages = _result.count
            _self.bannerPageControl.currentPage = 0
            _self.bannerLoadingIndicator.stopAnimating()
            _self.bannerCollectionView.fadeIn()
        }
    }
    
    func setupCollectionViews() {
        categoryCollectionView = UICollectionView(layout: categoryFlowLayout)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.allowsMultipleSelection = false
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.register(CategorySelectorCollectionCell.self, forCellWithReuseIdentifier: "\(CategorySelectorCollectionCell.self)")
        contentView.addSubview(categoryCollectionView!)
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.backgroundColor = .clear
        bannerCollectionView.register(BannerCollectionCell.self, forCellWithReuseIdentifier: "\(BannerCollectionCell.self)")
        contentView.addSubview(bannerCollectionView)
        contentView.bringSubviewToFront(bannerCollectionView)
        contentView.addSubview(bannerPageControl)
        bannerPageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(bannerPageControl.currentPage) * bannerCollectionView.frame.size.width
        bannerCollectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        guard let cell = bannerCollectionView.cellForItem(at: IndexPath(item: bannerPageControl.currentPage, section: 0)) as? BannerCollectionCell else { return }
        guard let image = cell.bannerImageView.image else { return }
        handleNewColor(image: image)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isPagingEnabled {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            bannerPageControl.currentPage = Int(pageNumber)
            guard let cell = bannerCollectionView.cellForItem(at: IndexPath(item: Int(pageNumber), section: 0)) as? BannerCollectionCell else { return }
            guard let image = cell.bannerImageView.image else { return }
            handleNewColor(image: image)
        }
    }
    
    private func handleNewColor(image: UIImage) {
        do {
            let color = try image.dominantColors()[0]
            self.backgroundTopColor = color.cgColor
            self.newTableViewColor?(color)
            self.gradientLayer.colors = [backgroundTopColor, UIColor.white.cgColor]
        } catch {
            print(error)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
}

extension HomeHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategorySelectorCollectionCell else { return }
            cell.selectedState()
            let item = indexPath.item
            let category = selectorCategories[item]
            onCategorySelectorTap?(category)
            print(indexPath.item, indexPath.section)
        } else {
            return
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategorySelectorCollectionCell else { return }
        cell.deselectedState()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == categoryCollectionView {
            return selectorCategories.count
        } else {
            return banners.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = indexPath.item
        switch collectionView {
        case categoryCollectionView:
            let category = selectorCategories[item]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(CategorySelectorCollectionCell.self)",
                for: indexPath
            ) as? CategorySelectorCollectionCell else {
                return UICollectionViewCell()
            }
            cell.categoryLabel.setTitle(
                text: category.name ?? "",
                size: 14,
                weight: .regular,
                color: .black
            )
            if cell.isSelected { cell.selectedState() } else { cell.deselectedState() }
            return cell
            
        case bannerCollectionView:
            let banner = banners[item]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(BannerCollectionCell.self)",
                for: indexPath
            ) as? BannerCollectionCell else {
                return UICollectionViewCell()
            }
            cell.fill(with: banner)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
                if item == 0 {
                    if let image = cell.bannerImageView.image {
                        handleNewColor(image: image)
                    }
                }
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == categoryCollectionView {
                return CGSize(width: 150, height: 40)
            } else {
                return CGSize(width: UIScreen.main.bounds.width, height: 150)
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView
        , layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

}

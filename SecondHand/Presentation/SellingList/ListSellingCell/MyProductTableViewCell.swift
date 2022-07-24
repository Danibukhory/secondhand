//
//  MyProductTableViewCell.swift
//  SecondHand
//
//  Created by Daffashiddiq on 21/07/22.
//

import UIKit

final class MyProductCell: UITableViewCell {
    private lazy var productDetails: [SHSellerProductResponse]? = nil
    private lazy var orderDetails: [SHSellerOrderResponse]? = nil
    private lazy var sellerSoldProduct: [SHSellerProductResponse]? = {
        guard let _sellerProduct = productDetails else { return nil }
        let soldProduct = _sellerProduct.filter { product in
            return product.status == "sold"
        }
        return soldProduct
    }()
    
    typealias DidSelectCategory = (Int) -> Void
    var didSelectCategory: DidSelectCategory?
    var selectedCategory: Int?
    
    typealias DidSelectAddProduct = () -> Void
    var didSelectAddProduct: DidSelectAddProduct?
    
    typealias DidSelectMyProduct = (SHSellerProductResponse) -> Void
    var didSelectMyProduct: DidSelectMyProduct?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCategoryView()
        setupProductView()
        setupView()
        setupConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var categoryLabel: [String] = ["Produk", "Diminati", "Terjual"]
    private lazy var categoryImage: [String] = ["img-sh-box","img-sh-heart","img-sh-dollar-sign"]
    var collectionCategoryView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    var collectionProductView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
}
extension MyProductCell {
    private func setupView() {
        contentView.addSubviews(
            collectionCategoryView,
            collectionProductView
        )
    }
    private func setupConstraint() {
        let collectionProductHeight = UIScreen.main.bounds.height - 170
        
        NSLayoutConstraint.activate([
            collectionCategoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionCategoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionCategoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionCategoryView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionProductView.topAnchor.constraint(equalTo: collectionCategoryView.bottomAnchor),
            collectionProductView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionProductView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionProductView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionProductView.heightAnchor.constraint(equalToConstant: collectionProductHeight),
        ])
    }
    private func setupCategoryView() {
        collectionCategoryView.translatesAutoresizingMaskIntoConstraints = false
        collectionCategoryView.showsHorizontalScrollIndicator = false
        collectionCategoryView.allowsMultipleSelection = false
        collectionCategoryView.dataSource = self
        collectionCategoryView.delegate = self
        collectionCategoryView.backgroundColor = .clear
        collectionCategoryView.register(ListCategoryViewCell.self, forCellWithReuseIdentifier: "\(ListCategoryViewCell.self)")
    }
    private func setupProductView() {
        collectionProductView.translatesAutoresizingMaskIntoConstraints = false
        collectionProductView.showsVerticalScrollIndicator = false
        collectionProductView.dataSource = self
        collectionProductView.delegate = self
        collectionProductView.backgroundColor = .clear
        collectionProductView.register(ListProductDashedCell.self, forCellWithReuseIdentifier: "\(ListProductDashedCell.self)")
        collectionProductView.register(ListProductViewCell.self, forCellWithReuseIdentifier: "\(ListProductViewCell.self)")
        collectionProductView.register(NoProductAvailableCell.self, forCellWithReuseIdentifier: "\(NoProductAvailableCell.self)")
    }
    func fill(productDetails dataProduct: [SHSellerProductResponse]?, orderDetails dataOrder: [SHSellerOrderResponse]?) {
        self.productDetails = dataProduct
        self.orderDetails = dataOrder
    }
}

extension MyProductCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionCategoryView:
            return 3
        case collectionProductView:
            if selectedCategory == 0 {
                return productDetails!.count + 1
            }
            else if selectedCategory == 1{
                if orderDetails!.count > 0 {
                    return orderDetails!.count
                } else {
                    return 1
                }
            } else {
                if sellerSoldProduct!.count > 0 {
                    return sellerSoldProduct!.count
                } else {
                    return 1
                }
            }
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ind = indexPath.item
        switch collectionView {
        case collectionCategoryView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListCategoryViewCell.self)", for: indexPath) as? ListCategoryViewCell else { return UICollectionViewCell() }
            cell.setItemValue(name: categoryLabel[ind], image: categoryImage[ind])
            if ind == selectedCategory {
                cell.selectedState()
                collectionCategoryView.selectItem(at: IndexPath(item: ind, section: 0), animated: true, scrollPosition: .centeredVertically)
            }
            return cell
        case collectionProductView:
            if selectedCategory == 0 {
                switch ind {
                case 0:
                    guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListProductDashedCell.self)", for: indexPath) as? ListProductDashedCell else { return UICollectionViewCell() }
                    return cell1
                default:
                    guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListProductViewCell.self)", for: indexPath) as? ListProductViewCell else { return UICollectionViewCell() }
                    cell2.fill(sellerResponse: productDetails?[ind-1])
                    return cell2
                }
            }
            else if selectedCategory == 1 {
                if orderDetails!.count > 0 {
                    guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListProductViewCell.self)", for: indexPath) as? ListProductViewCell else { return UICollectionViewCell() }
                    cell2.fill(sellerResponse: orderDetails?[ind])
                    return cell2
                } else {
                    guard let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NoProductAvailableCell.self)", for: indexPath) as? NoProductAvailableCell else { return UICollectionViewCell() }
                    return noCell
                }
                
            } else {
                if sellerSoldProduct!.count > 0 {
                    guard let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ListProductViewCell.self)", for: indexPath) as? ListProductViewCell else { return UICollectionViewCell() }
                    cell3.fill(sellerResponse: sellerSoldProduct?[ind])
                    return cell3
                } else {
                    guard let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NoProductAvailableCell.self)", for: indexPath) as? NoProductAvailableCell else { return UICollectionViewCell() }
                    return noCell
                }
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionCategoryView:
            return CGSize(width: 120, height: 40)
        case collectionProductView:
            let screenRect: CGRect = UIScreen.main.bounds
            if selectedCategory == 1, orderDetails!.count == 0 {
                return CGSize(width: screenRect.width - 20, height: screenRect.width - 20)
            }
            else if selectedCategory == 2, sellerSoldProduct!.count == 0 {
                return CGSize(width: screenRect.width - 20, height: screenRect.width - 20)
            } else {
                var width: CGFloat = 0
                let height: CGFloat = 206
                let screenWidth: CGFloat = screenRect.width
                width = (screenWidth - 48) / 2
                return CGSize(width: width, height: height)
            }
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ind = indexPath.item
        switch collectionView {
        case collectionCategoryView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? ListCategoryViewCell else { return }
            cell.selectedState()
            didSelectCategory?(ind)
            
        case collectionProductView:
            if ind == 0, selectedCategory == 0 {
                didSelectAddProduct?()
            } else if selectedCategory == 0 {
                let productItem = productDetails?[ind-1]
                didSelectMyProduct?(productItem!)
                print("kepencet")
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionCategoryView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? ListCategoryViewCell else { return }
            cell.deselectedState()
        default:
            break
        }
    }
}

final class NoProductAvailableCell: UICollectionViewCell {
    private lazy var noImageView: UIImageView = UIImageView(image: UIImage(named: "img-no-data"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(noImageView)
        noImageView.contentMode = .scaleAspectFit
        
        noImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            noImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            noImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

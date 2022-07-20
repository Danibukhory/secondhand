//
//  SellerPreviewViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 11/07/22.
//

import UIKit
import Kingfisher

class SellerPreviewViewController: UIViewController {
        
    var userResponse: SHUserResponse?
    var imageData: UIImage?
    var productName: String?
    var productDesc: String?
    var productPrice: String?
    var productCategory: String?
    var productCategoryID: Int?
    private lazy var isOffered: Bool = false
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let contentPhotoView = UIView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var photoForProduct: [UIImage] = []
    
    private lazy var photoProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img-home-product-placeholder-1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var backButton: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        
        let arrow = UIImageView()
        arrow.image = UIImage(systemName: "arrow.left")
        arrow.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrow)
        
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrow.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            view.widthAnchor.constraint(equalToConstant: 24),
            view.heightAnchor.constraint(equalToConstant: 24),
        ])
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissThisView))
        view.addGestureRecognizer(tapRecognizer)

        return view
    }()
    
    @objc private func dismissThisView() {
        self.dismiss(animated: true)
    }
    
    private lazy var pageControl = UIPageControl()
    
    private lazy var productDetail: UIView = {
        let productView = UIView()
        scrollView.addSubview(productView)
        productView.backgroundColor = .white
        productView.clipsToBounds = true
        productView.layer.cornerRadius = 16
        productView.layer.shadowRadius = 4
        productView.layer.masksToBounds = false
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOpacity = 0.15
        productView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        let productName = UILabel()
        productName.setTitle(text: (self.productName ?? "Product name not available"), size: 14, weight: .medium, color: .black)
        
        let productCategory = UILabel()
        productCategory.setTitle(text: (self.productCategory ?? "Category not available"), size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
        let productPrice = UILabel()
        let price = Int(self.productPrice!)?.convertToCurrency()
        productPrice.setTitle(text: price ?? "Price not available", size: 14, weight: .medium, color: .black)
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false
        productCategory.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        
        productView.addSubviews(
            productName,
            productCategory,
            productPrice
        )
        
        NSLayoutConstraint.activate([
            
            productName.topAnchor.constraint(equalTo: productView.topAnchor, constant: 16),
            productName.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 24),
            productName.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -24),
            
            productCategory.topAnchor.constraint(equalTo: productName.bottomAnchor),
            productCategory.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 24),
            productCategory.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -24),
            
            productPrice.topAnchor.constraint(equalTo: productCategory.bottomAnchor),
            productPrice.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 24),
            productPrice.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -24),
            productPrice.bottomAnchor.constraint(equalTo: productView.bottomAnchor, constant: -16),
        ])

        
        return productView
    }()

    private lazy var productOwner: UIView = {
        let productView = UIView()
        scrollView.addSubview(productView)
        productView.backgroundColor = .white
        productView.clipsToBounds = true
        productView.layer.cornerRadius = 16
        productView.layer.shadowRadius = 4
        productView.layer.masksToBounds = false
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOpacity = 0.15
        productView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let imageView = UIImageView()
//        imageView.load(urlString: (userResponse?.imageURL!)!)
        if let url = URL(string: userResponse?.imageURL ?? "") {
            imageView.kf.setImage(with: url)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        let sellerName = UILabel()
        sellerName.setTitle(text: (self.userResponse?.fullName)!, size: 14, weight: .medium, color: .black)
        
        let sellerCity = UILabel()
        sellerCity.setTitle(text: (userResponse?.city ?? "Kota Jakarta"), size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        sellerName.translatesAutoresizingMaskIntoConstraints = false
        sellerCity.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        productView.addSubviews(
            imageView,
            sellerName,
            sellerCity
        )
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: productView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            
            sellerName.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -10),
            sellerName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            sellerName.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -16),
            
            sellerCity.topAnchor.constraint(equalTo: sellerName.bottomAnchor),
            sellerCity.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                               constant: 16),
        ])

        
        return productView
    }()
    
    private lazy var productDescription: UIView = {
        let productView = UIView()
        scrollView.addSubview(productView)
        productView.backgroundColor = .white
        productView.clipsToBounds = true
        productView.layer.cornerRadius = 16
        productView.layer.shadowRadius = 4
        productView.layer.masksToBounds = false
        productView.layer.shadowColor = UIColor.black.cgColor
        productView.layer.shadowOpacity = 0.15
        productView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let descLabel = UILabel()
        descLabel.setTitle(text: "Deskripsi", size: 14, weight: .medium, color: .black)
        
        let descDetails = UILabel()

        descDetails.setTitle(text: self.productDesc!, size: 14, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        descDetails.numberOfLines = 0
        
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descDetails.translatesAutoresizingMaskIntoConstraints = false
        
        productView.addSubviews(
            descLabel,
            descDetails
        )
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: productView.topAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 16),
            
            descDetails.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            descDetails.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 16),
            descDetails.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -16),
            descDetails.bottomAnchor.constraint(equalTo: productView.bottomAnchor, constant: -16),
        ])

        
        return productView
    }()
    
    private lazy var publishButton: SHButton = {
        let button = SHButton(frame: CGRect.zero, title: "Terbitkan", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(publishButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    @objc func publishButtonAction() {
        
        DispatchQueue.main.async {
            let callAPI = SecondHandAPI()
            callAPI.postProductAsSeller(
                with: self.productName!,
                description: self.productDesc!,
                basePrice: Int(self.productPrice!)!,
                category: self.productCategoryID!,
                location: (self.userResponse?.city)!,
                productPicture: self.imageData!
            )
        }
//        let vc = SellingListPageViewController()
//        vc.isPopUpEnabled = true
//        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true)
        self.tabBarController?.dismiss(animated: true)
        self.tabBarController?.selectedIndex = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupScrollView()
        setupContentView()
    }
    
    private func setupSubViews() {
        view.insetsLayoutMarginsFromSafeArea = false
        navigationController?.isNavigationBarHidden = true
       
        view.backgroundColor = .white
        view.addSubviews(
            scrollView,
            publishButton
        )
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            contentPhotoView,
            pageControl
        )
        
        contentPhotoView.addSubviews(collectionView,backButton)
        
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -48),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupContentView() {
        configurePhotoCollectionView()
        configurePageControl()
        
        contentPhotoView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        productDetail.translatesAutoresizingMaskIntoConstraints = false
        productOwner.translatesAutoresizingMaskIntoConstraints = false
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentPhotoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentPhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentPhotoView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contentPhotoView.heightAnchor.constraint(equalToConstant: 300),
            
            backButton.topAnchor.constraint(equalTo: contentPhotoView.topAnchor, constant: 44),
            backButton.leadingAnchor.constraint(equalTo: contentPhotoView.leadingAnchor, constant: 16),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentPhotoView.bottomAnchor, constant: -51),
            
            productDetail.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            productDetail.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            productDetail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productDetail.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 16),
            
            productOwner.topAnchor.constraint(equalTo: productDetail.bottomAnchor, constant: 16),
            productOwner.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            productOwner.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            productOwner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            productDescription.topAnchor.constraint(equalTo: productOwner.bottomAnchor, constant: 19),
            productDescription.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            productDescription.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            productDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(UIScreen.main.bounds.height/6)),
            
            publishButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            publishButton.heightAnchor.constraint(equalToConstant: 48),
            publishButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            publishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    private func configurePageControl() {
        self.pageControl.numberOfPages = 1
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = .clear
        self.pageControl.pageIndicatorTintColor = UIColor.systemGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    @objc func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
            collectionView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    private func configurePhotoCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SellerPreviewProductViewCell.self, forCellWithReuseIdentifier: "\(SellerPreviewProductViewCell.self)")
        
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentPhotoView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentPhotoView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentPhotoView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentPhotoView.trailingAnchor),
        ])
        
    }
    
}

extension SellerPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 //photoForProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SellerPreviewProductViewCell.self)", for: indexPath) as? SellerPreviewProductViewCell else {return UICollectionViewCell()}
        
        cell.setImage(to: self.imageData!)
        collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension SellerPreviewViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

final class SellerPreviewProductViewCell: UICollectionViewCell {
    
    var imageProduct: UIImage? = nil
    
    private lazy var photoProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.image = imageProduct ?? UIImage(named: "img-home-product-placeholder-1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setImage(to img: UIImage) {
        self.imageProduct = img
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoProduct)
        
        photoProduct.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoProduct.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoProduct.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoProduct.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



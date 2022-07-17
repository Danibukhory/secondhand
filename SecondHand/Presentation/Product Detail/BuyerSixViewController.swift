//
//  BuyerSixViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 24/06/22.
//

import UIKit
import Kingfisher

class BuyerSixViewController: UIViewController {
    
    var buyerResponse: SHBuyerProductResponse?
    
    private lazy var orderedItem: [SHBuyerOrderResponse] = []
    private lazy var isOffered: Bool = false
    private lazy var popUpView: SHPopupView = SHPopupView(frame: CGRect.zero, popupType: .success, text: "Harga tawarmu berhasil dikirim ke penjual")
    private lazy var popupFailedView: SHPopupView = SHPopupView(frame: CGRect.zero, popupType: .failed, text: "Produk mencapai batas maksimal penawaran")
    
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissProductView))
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    }()
    
    @objc private func dismissProductView() {
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
        productName.setTitle(text: (buyerResponse?.name ?? "Dummy name"), size: 14, weight: .medium, color: .black)
        
        let productCategory = UILabel()
        productCategory.setTitle(text: (buyerResponse?.categories[0]?.name ?? "Category undefined"), size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
        let productPrice = UILabel()
        productPrice.setTitle(text:  (buyerResponse?.basePrice ?? 0).convertToCurrency(), size: 14, weight: .medium, color: .black)
        
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
        imageView.image = UIImage(named: "img-home-product-placeholder-1")
//        imageView.load(urlString: buyerResponse!.imageURL)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        let sellerName = UILabel()
        sellerName.setTitle(text: "Seller not recognized", size: 14, weight: .medium, color: .black)
        
        let sellerCity = UILabel()
        sellerCity.setTitle(text: (buyerResponse?.location ?? "Location not Available"), size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
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
        descDetails.setTitle(text: buyerResponse?.description ?? "Description not Available", size: 14, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
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
        let button = SHButton(frame: CGRect.zero, title: "Saya Tertarik dan ingin Nego", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        
        if !orderedItem.isEmpty {
            button.backgroundColor = UIColor(rgb: 0xD0D0D0)
            button.setActiveButtonTitle(string: "Menunggu respon penjual")
            button.isEnabled = false
        }
        
        return button
    }()
    
    @objc func showModal() {
        let vc = BuyerTenViewController()
//        vc.buyerResponse = self.buyerResponse
        vc.modalPresentationStyle = .overCurrentContext
        vc.changeDefaultHeight(to: view.frame.height/1.3)
        vc.delegate = self
        vc.buyerResponse = self.buyerResponse
        self.present(vc, animated: false)
//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        defer {
            group.notify(queue: .main) { [self] in
                setupSubViews()
                setupScrollView()
                setupContentView()
            }
        }
        group.enter()
        getOrderedItem()
        group.leave()
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
    
    private func getOrderedItem() {
        let apiCall = SecondHandAPI()
        apiCall.getBuyerOrders { [weak self] response, error in
            guard let _self = self else { return }
            if error == nil {
                guard let _response = response else { return }
                _self.orderedItem = _response.filter({ order in
                    return order.productID == _self.buyerResponse?.id
                })
                if !_self.orderedItem.isEmpty {
                    _self.publishButton.isEnabled = false
                    _self.publishButton.setActiveButtonTitle(string: "Menunggu Respon Penjual")
                }
            }
        }
    }
    
    private func configurePageControl() {
        self.pageControl.numberOfPages = 4
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
        collectionView.register(BuyerSixPhotoProductViewCell.self, forCellWithReuseIdentifier: "\(BuyerSixPhotoProductViewCell.self)")
        
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

extension BuyerSixViewController: ItemIsOfferedDelegate {
    func userDidOfferItem(info: Bool, code: Int?) {
        self.isOffered = info
//        self.viewDidLoad()
        if code != 400 {
            publishButton.backgroundColor = UIColor(rgb: 0xD0D0D0)
            publishButton.setActiveButtonTitle(string: "Menunggu respon penjual")
            publishButton.isEnabled = false
            
            view.addSubview(popUpView)
            popUpView.translatesAutoresizingMaskIntoConstraints = false
            popUpView.isPresenting.toggle()
            
            NSLayoutConstraint.activate([
                popUpView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        } else {
            view.addSubview(popupFailedView)
            popupFailedView.translatesAutoresizingMaskIntoConstraints = false
            popupFailedView.isPresenting.toggle()
            
            NSLayoutConstraint.activate([
                popupFailedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                popupFailedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                popupFailedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }
        
    }
    
    
}

extension BuyerSixViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 //photoForProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BuyerSixPhotoProductViewCell.self)", for: indexPath) as? BuyerSixPhotoProductViewCell else {return UICollectionViewCell()}
        
        cell.setImage(to: buyerResponse?.imageURL ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension BuyerSixViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

final class BuyerSixPhotoProductViewCell: UICollectionViewCell {
    
    private lazy var photoProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setImage(to img: String) {
        let url = URL(string: img)
        photoProduct.kf.setImage(with: url)
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



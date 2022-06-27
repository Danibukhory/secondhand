//
//  SellingPageController.swift
//  SecondHand
//
//  Created by Raden Dimas on 27/06/22.
//

import UIKit

final class SellingPageController: UIViewController {

    var pages = [UIViewController]()
    let items  = ["Produk","Diminati" ,"Terjual"]
    let myImageCategories = ["img-sh-box","img-sh-heart","img-sh-dollar-sign"]
    let segmentedControlBackgroundColor = UIColor(rgb: 0xE2D4f0)
    let initialPage = 0
    private var pageController = UIPageViewController()
    
    private lazy var productButton: SHBorderedButton = { // change with UIView
       let button = SHBorderedButton()
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.tintColor = .white
        button.setActiveButtonTitle(string: "  Produk")
        button.setImage(image: myImageCategories[0])
        return button
    }()
    
    private lazy var recomendedButton: SHBorderedButton = {
       let button = SHBorderedButton()
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setActiveButtonTitle(string: "  Diminati")
        button.setImage(image: myImageCategories[1])
        return button
    }()
    
    private lazy var selledButton: SHBorderedButton = {
       let button = SHBorderedButton()
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setActiveButtonTitle(string: "  Terjual")
        button.setImage(image: myImageCategories[2])
       return button
    }()
   
    
    private lazy var topContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 1.8
        return containerView
    }()
    
    private lazy var imageTopView: UIImageView = {
        let imageTop = UIImageView()
        imageTop.translatesAutoresizingMaskIntoConstraints = false
        imageTop.backgroundColor = .blue
        imageTop.layer.cornerRadius = 12
        return imageTop
    }()
    
    private lazy var sellerNameLabel: UILabel = {
       let sellerName = UILabel()
        sellerName.translatesAutoresizingMaskIntoConstraints = false
        sellerName.text = "Nama Penjual"
        sellerName.font = UIFont(name: "Poppins-SemiBold", size: 14)
        return sellerName
    }()
    
    private lazy var sellerCityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = "Kota"
        cityLabel.font = UIFont(name: "Poppins-Light", size: 10)
        return cityLabel
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        let attributedTitle = NSAttributedString(
            string: "Edit",
            attributes: [.font : UIFont(name: "Poppins-Regular", size: 12)!]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private lazy var catStackView: UIStackView = {
        let segmentedControlButtons: [UIButton] = [
            productButton,
            recomendedButton,
            selledButton,
        ]
        let stackView = UIStackView(arrangedSubviews: segmentedControlButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var catScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: .zero, height: 50)
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var pagingContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        productButton.isUserInteractionEnabled = false
        setup()
        configure()
    }
    
    private func setup() {
        let page1 = ProductListViewController()
        let page2 = RecomendationListViewController()
        let page3 = SoldOutListViewController()
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController.view.backgroundColor = .clear

        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageController.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        addChild(self.pageController)

        pagingContainer.addSubview(pageController.view)
        self.pageController.didMove(toParent: self)
     
    }
    
    private func configure() {
        
        view.addSubview(topContainerView)
        view.addSubview(pagingContainer)
        topContainerView.addSubviews(
            imageTopView,
            sellerNameLabel,
            sellerCityLabel,
            editButton
        )
        
        view.addSubview(catScrollView)
        catScrollView.addSubview(catStackView)
        
        NSLayoutConstraint.activate([
            pagingContainer.topAnchor.constraint(equalTo: catScrollView.bottomAnchor, constant: 20),
            pagingContainer.leadingAnchor.constraint(equalTo: catScrollView.leadingAnchor,constant: 16),
            pagingContainer.trailingAnchor.constraint(equalTo: catScrollView.trailingAnchor,constant: -16),
            pagingContainer.heightAnchor.constraint(equalToConstant: 400),
            
            pageController.view.topAnchor.constraint(equalTo: pagingContainer.topAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: pagingContainer.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: pagingContainer.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: pagingContainer.trailingAnchor),
            
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor,constant:125),
            topContainerView.heightAnchor.constraint(equalToConstant: 80),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            
            imageTopView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor,constant: 16),
            imageTopView.topAnchor.constraint(equalTo: topContainerView.topAnchor,constant:16),
            imageTopView.heightAnchor.constraint(equalToConstant: 48),
            imageTopView.widthAnchor.constraint(equalToConstant: 48),
            
            sellerNameLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 16),
            sellerNameLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),

            sellerCityLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor, constant: 10),
            sellerCityLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),
            
            editButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 60),
            editButton.heightAnchor.constraint(equalToConstant: 26),
            
            catScrollView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
            catScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            catScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            catStackView.topAnchor.constraint(equalTo: catScrollView.topAnchor),
            catStackView.leadingAnchor.constraint(equalTo: catScrollView.leadingAnchor,constant: 12),
            catStackView.trailingAnchor.constraint(equalTo: catScrollView.trailingAnchor,constant: -12),
            catStackView.heightAnchor.constraint(equalToConstant: 40),
        
        ])
    
        productButton.backgroundColor = UIColor(rgb: 0x7126B5)
        recomendedButton.backgroundColor = UIColor(rgb:  0xE2D4f0)
        selledButton.backgroundColor = UIColor(rgb:  0xE2D4f0)

        let segmentedControlButtons: [UIButton] = [
            productButton,
            recomendedButton,
            selledButton,
        ]
        
        segmentedControlButtons.forEach {$0.addTarget(self, action: #selector(handleSegmentedControlButtons(sender:)), for: .touchUpInside)}
                
    }
    
    private func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        self.pageController.setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func handleSegmentedControlButtons(sender: UIButton) {
        
        let segmentedControlButtons: [UIButton] = [
            productButton,
            recomendedButton,
            selledButton
        ]
        
        if sender == segmentedControlButtons[0] {
            goToSpecificPage(index: 0, ofViewControllers: pages)
            sender.isUserInteractionEnabled = false
            recomendedButton.isUserInteractionEnabled = true
            selledButton.isUserInteractionEnabled = true
        } else if sender == segmentedControlButtons[1] {
            goToSpecificPage(index: 1, ofViewControllers: pages)
            productButton.isUserInteractionEnabled = true
            sender.isUserInteractionEnabled = false
            selledButton.isUserInteractionEnabled = true
        } else {
            goToSpecificPage(index: 2, ofViewControllers: pages)
            productButton.isUserInteractionEnabled = true
            recomendedButton.isUserInteractionEnabled = true
            sender.isUserInteractionEnabled = false
        }
        
        for button in segmentedControlButtons {
            if button == sender {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) {
                    button.backgroundColor = UIColor(rgb: 0x7126B5)
                    button.tintColor = .white
                }

            } else {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) { [weak self] in
                    button.backgroundColor = self?.segmentedControlBackgroundColor
                    button.tintColor = .label
                }
            }
        }
    }
}

//extension UIPageViewController {
//
//    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
//        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
//    }
//}

// test for pageview controler in uiviewcontroller

//override func viewDidLoad() {
//        super.viewDidLoad()
//
//        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageContainer.delegate = self
//        pageContainer.dataSource = self
//        pageContainer.setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
//        view.addSubview(pageContainer.view)
//
//    }

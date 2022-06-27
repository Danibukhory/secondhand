//
//  CategoriesRowCollectionViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 26/06/22.
//

import UIKit

protocol CategoriesDelegate: AnyObject {
    func setCategories(_ category: Int)
}

final class CategoriesTableViewCell: UITableViewCell {
    
    static let identifier: String = "ct-tb-cell"
    var currentSelected:Int = 0
    let myTitleArr = ["Produk","Diminati" ,"Terjual"]
    let myImageCategories = ["img-sh-box","img-sh-heart","img-sh-dollar-sign"]
    var testModel = TestModel()
    
    weak var delegate: CategoriesDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130,height: 44)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CategoriesRowCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesRowCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageView = SellingPageController()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            
        ])
    }
    
    @objc private func onCellTapped() {
        debugPrint("clicked")
    }
    
}



extension CategoriesTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesRowCollectionViewCell.identifier, for: indexPath) as? CategoriesRowCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.categoryLabel.text = myTitleArr[indexPath.row]
        cell.categoryImageView.image = UIImage(named: myImageCategories[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.categoryImageView.tintColor = currentSelected == indexPath.row ? UIColor.white : UIColor.black
        cell.categoryView.backgroundColor = currentSelected == indexPath.row ? UIColor(rgb: 0x7126B5) : UIColor(rgb: 0xE2D4f0)
        cell.categoryImageView.tintColor = currentSelected == indexPath.row ? UIColor.white : UIColor.black
        cell.categoryLabel.textColor = currentSelected == indexPath.row ? UIColor.white : UIColor.black
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
//        cell.categoryView.addGestureRecognizer(tapRecognizer)
//        cell.categoryView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelected = indexPath.row
        
        testModel.category = currentSelected
        delegate?.setCategories(currentSelected)
        
//        if
        
        
//        debugPrint(currentSelected)
        collectionView.reloadData()
    }
        
}

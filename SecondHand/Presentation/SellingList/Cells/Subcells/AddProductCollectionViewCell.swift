//
//  AddProductCollectionViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 26/06/22.
//

import UIKit

final class AddProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ap-cv-cell"
    
    private lazy var containerAddView: UIView = {
        let addView = UIView()
        addView.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.gray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)

        
        return addView
    }()
        
    private lazy var addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img-sh-plus")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.text = "Tambahkan Produk"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(containerAddView)

        containerAddView.addSubviews(
            addImageView,
            addLabel
        )
        
        NSLayoutConstraint.activate([
            
            containerAddView.heightAnchor.constraint(equalToConstant: 206),
            containerAddView.widthAnchor.constraint(equalToConstant: 156),
            
            addImageView.centerYAnchor.constraint(equalTo: containerAddView.centerYAnchor),
            addImageView.centerXAnchor.constraint(equalTo: containerAddView.centerXAnchor),
            addImageView.heightAnchor.constraint(equalToConstant: 28),
            addImageView.widthAnchor.constraint(equalToConstant: 28),
            
            addLabel.centerXAnchor.constraint(equalTo: containerAddView.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: addImageView.bottomAnchor, constant: 10),
            
        ])
    }
}

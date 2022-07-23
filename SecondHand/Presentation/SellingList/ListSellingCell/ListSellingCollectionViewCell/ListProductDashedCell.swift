//
//  ListProductDashedCell.swift
//  SecondHand
//
//  Created by Daffashiddiq on 21/07/22.
//

import UIKit

final class ListProductDashedCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var photoIcon: UIImageView = {
        let photo = UIImage(named: "img-sh-plus")
        let photoView = UIImageView(image: photo)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .center

        return photoView
    }()
    private lazy var dashedView: UIView = {
        let color = UIColor(rgb: 0xD0D0D0).cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.width
        let width = (screenWidth - 48) / 2
        let shapeRect = CGRect(x: 0, y: 0, width: width, height: 206)


        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: 68, y: 103)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        let shapeView = UIView()
        shapeView.layer.addSublayer(shapeLayer)
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        shapeView.clipsToBounds = true
        shapeView.layer.cornerRadius = 12
        
        return shapeView
    }()
    
    private func configure() {
        contentView.addSubviews(
            dashedView,
            photoIcon
        )
        
        NSLayoutConstraint.activate([
            dashedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dashedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dashedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dashedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dashedView.heightAnchor.constraint(equalToConstant: 206),
            
            photoIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoIcon.widthAnchor.constraint(equalToConstant: 14),
            photoIcon.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
}

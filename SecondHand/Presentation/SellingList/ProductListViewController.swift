//
//  ProductListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 27/06/22.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is product list view"
        return label
    }()
    
    private lazy var containerAddView: UIView = {
        let addView = UIView()
        addView.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.gray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        let frameSize = 150
        let shapeRect = CGRect(x: 0, y: 0, width: 156, height: 250)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: 78, y: 103)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        addView.layer.addSublayer(shapeLayer)

        return addView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    private func configure() {
                
        view.addSubview(containerAddView)
        
        NSLayoutConstraint.activate([
            containerAddView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 1),
            containerAddView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -1),
            containerAddView.topAnchor.constraint(equalTo: view.topAnchor,constant: 25)
        ])
        
    }
    

}

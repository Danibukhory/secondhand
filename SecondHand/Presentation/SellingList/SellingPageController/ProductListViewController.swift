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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    private func configure() {
        
        view.addSubview(productLabel)
        
        NSLayoutConstraint.activate([
            
        
            productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    

}

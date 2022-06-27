//
//  SoldOutListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 27/06/22.
//

import UIKit

final class SoldOutListViewController: UIViewController {

    private lazy var soldoutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is soldout list view"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    private func configure() {
        
        view.addSubview(soldoutLabel)
        
        NSLayoutConstraint.activate([
            soldoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            soldoutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    


}

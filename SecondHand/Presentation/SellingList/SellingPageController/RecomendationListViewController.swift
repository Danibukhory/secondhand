//
//  RecomendationListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 27/06/22.
//

import UIKit

final class RecomendationListViewController: UIViewController {
    
    private lazy var reccomendationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is reccomendation list view"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configure()
        
    }
    
    private func configure() {
        
        view.addSubview(reccomendationLabel)
        
        NSLayoutConstraint.activate([
            
        
            reccomendationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reccomendationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
    }
    
}

//
//  RecomendationListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 27/06/22.
//

import UIKit

final class RecomendationListViewController: UIViewController {
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Belum ada produkmu yang diminati nih, sabar ya rejeki enggak kemana kok"
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "img-no-data")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    private func configure() {
        view.addSubview(imageView)
        view.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            noDataLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            noDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            noDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16)
        ])
    }
    
}

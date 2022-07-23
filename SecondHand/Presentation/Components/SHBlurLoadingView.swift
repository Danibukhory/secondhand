//
//  SHBlurLoadingView.swift
//  SecondHand
//
//  Created by Bagas Ilham on 21/07/22.
//

import UIKit

class SHBlurLoadingView: UIView {
    var blurEffect = UIBlurEffect(style: .regular)
    var blurredLoadingView = UIVisualEffectView()
    var loadingIndicator = UIActivityIndicatorView()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defineLayout() {
        self.alpha = 0
        self.addSubview(blurredLoadingView)
        blurredLoadingView.contentView.addSubview(loadingIndicator)
        
        blurredLoadingView.translatesAutoresizingMaskIntoConstraints = false
        blurredLoadingView.effect = blurEffect
        blurredLoadingView.layer.cornerRadius = 12
        blurredLoadingView.clipsToBounds = true
        blurredLoadingView.alpha = 0
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.style = .medium
        loadingIndicator.color = .label
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 200),
            self.widthAnchor.constraint(equalTo: self.heightAnchor),
            
            blurredLoadingView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurredLoadingView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurredLoadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blurredLoadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: blurredLoadingView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: blurredLoadingView.centerYAnchor)
        ])
    }
}

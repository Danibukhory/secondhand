//
//  BannerCollectionCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 17/07/22.
//

import UIKit
import Kingfisher

final class BannerCollectionCell: UICollectionViewCell {
    
    typealias OnImageFinishLoading = () -> Void
    var onImageFinishLoading: OnImageFinishLoading?
    
    var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            contentView.heightAnchor.constraint(equalToConstant: 150),
            
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            bannerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func fill(with data: SHBannerResponse) {
        let imageUrl = URL(string: data.imageURL)
        if let url = imageUrl {
            bannerImageView.kf.indicatorType = .activity
            bannerImageView.kf.setImage(with: url, options: [.transition(.fade(0.25)), .cacheOriginalImage])
        }
    }
    
}

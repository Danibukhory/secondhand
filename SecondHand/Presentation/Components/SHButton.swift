//
//  SHButton.swift
//  SecondHand
//
//  Created by Bagas Ilham on 14/06/22.
//
import UIKit

final class SHButton: UIButton {
    
    enum buttonType {
        case filled
        case bordered
        case ghost
    }
    
    enum buttonSizeType: CGFloat {
        case regular = 48
        case small = 36
    }
    
    init(frame: CGRect, title: String, type: buttonType, size: buttonSizeType) {
        super.init(frame: frame)
        configure(size: size.rawValue, type: type)
        setActiveButtonTitle(string: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(size: CGFloat, type: buttonType) {
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor(rgb: 0x7126B5)
        layer.cornerRadius = 16
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        switch type {
        case .filled:
            configuration = .filled()
        case .bordered:
            configuration = .borderless()
            tintColor = .black
            layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
            layer.borderWidth = 1
        case .ghost:
            configuration = .plain()
        }
    }
    
    func setActiveButtonTitle(string: String) {
        let attributedTitle = NSAttributedString(
            string: string,
            attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!]
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setImageButton(image: String) {
        self.configuration?.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        self.configuration?.imagePlacement = .leading
    }
    
}

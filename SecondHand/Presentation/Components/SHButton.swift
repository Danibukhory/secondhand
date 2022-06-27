//
//  SHButton.swift
//  SecondHand
//
//  Created by Bagas Ilham on 14/06/22.
//
import UIKit

enum buttonSizeType: CGFloat {
    case regular = 48
    case small = 36
}

final class SHDefaultButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configuration = .filled()
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor(rgb: 0x7126B5)
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func setActiveButtonTitle(string: String) {
        let attributedTitle = NSAttributedString(
            string: string,
            attributes: [.font : UIFont(name: "Poppins-Regular", size: UIFont.buttonFontSize)!]
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

final class SHBorderedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configuration = .bordered()
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor.black
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func setActiveButtonTitle(string: String) {
        let attributedTitle = NSAttributedString(
            string: string,
            attributes: [.font : UIFont(name: "Poppins-Regular", size: UIFont.buttonFontSize)!]
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setImage(image: String) {
        self.configuration?.image = UIImage(named: image)
        self.configuration?.imagePlacement = .leading
    }
}

final class SHGhostButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor(rgb: 0x7126B5)
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func setActiveButtonTitle(string: String) {
        let attributedTitle = NSAttributedString(
            string: string,
            attributes: [.font : UIFont(name: "Poppins-Regular", size: UIFont.buttonFontSize)!]
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }
}


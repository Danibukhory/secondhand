//
//  SHLabelView.swift
//  SecondHand
//
//  Created by Daffashiddiq on 06/07/22.
//

import UIKit

final class SHLabelView: UILabel {
    init(frame: CGRect, title name: String) {
        super.init(frame: frame)
        self.text = name
        self.font = UIFont(name: "Poppins-Regular", size: 12)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  NavigationBar.swift
//  SecondHand
//
//  Created by Bagas Ilham on 16/06/22.
//

import UIKit

extension UINavigationBar {
    func useSHLargeTitle() {
        self.prefersLargeTitles = true
//        self.isTranslucent = false
//        self.backgroundColor = .white
//        self.barTintColor = .white
        self.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "Poppins-Bold", size: 16)!
        ]
        self.largeTitleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "Poppins-Bold", size: 28)!
        ]
//        let backImage = UIImage(systemName: "chevron.left")
        self.tintColor = .black
    }
}

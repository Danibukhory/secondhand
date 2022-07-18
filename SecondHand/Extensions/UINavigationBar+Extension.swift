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
        self.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "Poppins-Medium", size: 16)!
        ]
        self.largeTitleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "Poppins-Bold", size: 28)!
        ]
        self.tintColor = .black
    }
    
    func useSHTitle() {
        self.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "Poppins-Medium", size: 16)!
        ]
        self.tintColor = .black
    }
}

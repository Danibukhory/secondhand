//
//  SignUpResponse.swift
//  SecondHand
//
//  Created by Raden Dimas on 03/07/22.
//

import Foundation

struct SignUpResponse: Codable {
    let id: Int
    let fullName: String
    let email: String
    let password: String
    let phoneNumber: Int
    let address: String
    let imageUrl: String
    let city: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case password
        case phoneNumber = "phone_number"
        case address
        case imageUrl = "image_url"
        case city
        case createdAt
        case updatedAt
    }
    
}

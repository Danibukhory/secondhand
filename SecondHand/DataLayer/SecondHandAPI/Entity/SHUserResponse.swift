//
//  SHUserResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 30/06/22.
//

import Foundation

struct SHUserResponse: Codable {
    let id: Int?
    let fullName, email, password, phoneNumber: String?
    let address: String?
    let imageURL: String?
    let city, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, password
        case phoneNumber = "phone_number"
        case address
        case imageURL = "image_url"
        case city, createdAt, updatedAt
    }
}

struct SignInResponse: Codable {
    var id: Int? = 0
    var name: String? = ""
    var email: String? = ""
    var accessToken: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case accessToken = "access_token"
    }
}

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

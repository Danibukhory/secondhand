//
//  SHUserResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 30/06/22.
//

import Foundation

struct SHUserResponse: Codable {
    let id: Int
    let fullName, email: String
    let phoneNumber, address: String?
    let imageURL: String?
    let city: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phoneNumber = "phone_number"
        case address
        case imageURL = "image_url"
        case city
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

struct SignInDetailResponse: Codable {
    let id: Int
    let fullName, email, password, phoneNumber: String
    let address: String
    let imageURL: String
    let city, createdAt, updatedAt: String
    
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

struct SignUpResponse: Codable {
    let id: Int
    let fullName, email, password, phoneNumber: String
    let address: String
    let imageURL: String?
    let city, updatedAt, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, password
        case phoneNumber = "phone_number"
        case address
        case imageURL = "image_url"
        case city, updatedAt, createdAt
    }
}

//
//  SHUserResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 30/06/22.
//

import Foundation

struct SHUserResponse: Codable {
    let id: Int
    let fullName, email, phoneNumber, address: String
    let imageURL: String
    let city: String

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

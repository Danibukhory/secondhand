//
//  SHPostProduct.swift
//  SecondHand
//
//  Created by Daffashiddiq on 30/06/22.
//

import Foundation

// MARK: - PostProduct
struct PostProduct: Codable {
    let id: Int
    let name, postProductDescription: String
    let basePrice: Int
    let imageURL: String
    let imageName, location: String
    let userID: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case postProductDescription = "description"
        case basePrice = "base_price"
        case imageURL = "image_url"
        case imageName = "image_name"
        case location
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

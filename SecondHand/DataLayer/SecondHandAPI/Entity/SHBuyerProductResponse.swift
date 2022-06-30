//
//  SHBuyerProductResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 30/06/22.
//

import Foundation

struct SHBuyerProductResponse: Codable {
    let id: Int
    let name, welcomeDescription: String
    let basePrice: Int
    let imageURL: String
    let imageName, location: String
    let userID: Int
    let status, createdAt, updatedAt: String
    let categories: [SHCategoryResponse]

    enum CodingKeys: String, CodingKey {
        case id, name
        case welcomeDescription = "description"
        case basePrice = "base_price"
        case imageURL = "image_url"
        case imageName = "image_name"
        case location
        case userID = "user_id"
        case status, createdAt, updatedAt
        case categories = "Categories"
    }
}
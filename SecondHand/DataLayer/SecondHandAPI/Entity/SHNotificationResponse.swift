//
//  SHNotificationResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 28/06/22.
//

import Foundation

struct SHNotificationResponse: Codable {
    let id, productID: Int
    let productName, basePrice: String?
    let bidPrice: Int
    let imageURL: String?
    let transactionDate: String
    let status: OfferStatus?
    let sellerName: String
    let buyerName: String
    let receiverID: Int
    let read: Bool?
    let createdAt, updatedAt: String
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case productName = "product_name"
        case basePrice = "base_price"
        case bidPrice = "bid_price"
        case imageURL = "image_url"
        case transactionDate = "transaction_date"
        case status
        case sellerName = "seller_name"
        case buyerName = "buyer_name"
        case receiverID = "receiver_id"
        case read, createdAt, updatedAt
        case product = "Product"
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let name: String
    let description: String?
    let basePrice: Int
    let imageURL: String?
    let imageName: String?
    let location: String
    let userID: Int
    let status: ProductAvailabilityStatus?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description"
        case basePrice = "base_price"
        case imageURL = "image_url"
        case imageName = "image_name"
        case location
        case userID = "user_id"
        case status, createdAt, updatedAt
    }
}

enum ProductAvailabilityStatus: String, Codable {
    case available = "available"
    case sold = "sold"
}

enum OfferStatus: String, Codable {
    case accepted = "accepted"
    case acceptedDeclined = "accepted/declined"
    case bid = "bid"
    case declined = "declined"
}

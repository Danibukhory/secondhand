//
//  SHNotificationResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 28/06/22.
//

import Foundation

struct SHNotificationResponse: Codable {
    let id, productID: Int
    let productName: String
    let basePrice: String
    let bidPrice: Int?
    let imageURL: String
    let transactionDate: String?
    let status: String?
    let sellerName: String?
    let buyerName: String?
    let receiverID: Int
    let read: Bool
    let notificationType: String
    let orderID: Int?
    let createdAt, updatedAt: String?
    let product: SHNotificationProductResponse?
    let user: SHUserResponse?
    
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
        case read
        case notificationType = "notification_type"
        case orderID = "order_id"
        case createdAt, updatedAt
        case product = "Product"
        case user = "User"
    }
}

struct SHNotificationProductResponse: Codable {
    let id: Int
    let name, productDescription: String
//    let basePrice: Int
    let imageURL: String
    let imageName: String
    let location: String
    let userID: Int
    let status: String
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case productDescription = "description"
//        case basePrice = "base_price"
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

//enum OfferStatus: String, Codable {
//    case accepted = "accepted"
//    case acceptedDeclined = "accepted/declined"
//    case bid = "bid"
//    case declined = "declined"
//}

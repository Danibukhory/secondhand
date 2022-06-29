//
//  SHNotificationResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 28/06/22.
//

import Foundation

struct SHNotificationResponse: Codable {
    let id, productID, bidPrice: Int
    let transactionDate: String
    let status: String
    let sellerName: String
    let buyerName: String
    let receiverID: Int
    let imageURL: String
    let read: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case bidPrice = "bid_price"
        case transactionDate = "transaction_date"
        case status
        case sellerName = "seller_name"
        case buyerName = "buyer_name"
        case receiverID = "receiver_id"
        case imageURL = "image_url"
        case read, createdAt, updatedAt
    }
}

typealias Notifications = [SHNotificationResponse]

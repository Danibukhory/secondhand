//
//  SHBuyerOrderResponse.swift
//  SecondHand
//
//  Created by Daffashiddiq on 15/07/22.
//

import Foundation

// MARK: - SHBuyerOrderResponse
struct SHBuyerOrderResponse: Codable {
    let id, productID, buyerID, price: Int?
    let transactionDate: String?
    let productName, basePrice: String?
    let imageProduct: String?
    let status: String?
    let product: BuyerOrderProduct
    let user: BuyerOrderUser

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case buyerID = "buyer_id"
        case price
        case transactionDate = "transaction_date"
        case productName = "product_name"
        case basePrice = "base_price"
        case imageProduct = "image_product"
        case status
        case product = "Product"
        case user = "User"
    }
}

// MARK: - Product
struct BuyerOrderProduct: Codable {
    let name, productDescription: String?
    let basePrice: Int?
    let imageURL: String?
    let imageName, location: String?
    let userID: Int?
    let status: String?
    let user: BuyerOrderUser

    enum CodingKeys: String, CodingKey {
        case name
        case productDescription = "description"
        case basePrice = "base_price"
        case imageURL = "image_url"
        case imageName = "image_name"
        case location
        case userID = "user_id"
        case status
        case user = "User"
    }
}

// MARK: - User
struct BuyerOrderUser: Codable {
    let id: Int?
    let fullName, email, phoneNumber, address: String?
    let city: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phoneNumber = "phone_number"
        case address, city
    }
}

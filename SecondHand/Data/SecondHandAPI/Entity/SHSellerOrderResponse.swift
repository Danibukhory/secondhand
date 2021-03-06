//
//  SHSellerOrderResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 14/07/22.
//

import Foundation

struct SHSellerOrderResponse: Codable {
    let id, productID, buyerID, price: Int
    let transactionDate, productName: String
    let basePrice: Int
    let imageProduct: String
    let status, createdAt, updatedAt: String
    let product: SHOrderProduct
    let buyer: SHOrderBuyer
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case buyerID = "buyer_id"
        case price
        case transactionDate = "transaction_date"
        case productName = "product_name"
        case basePrice = "base_price"
        case imageProduct = "image_product"
        case status, createdAt, updatedAt
        case product = "Product"
        case buyer = "User"
    }
}

struct SHOrderProduct: Codable {
    let name, productDescription: String
    let basePrice: Int
    let imageURL: String
    let imageName, location: String
    let userID: Int
    let status: String
    let seller: SHOrderSeller

    enum CodingKeys: String, CodingKey {
        case name
        case productDescription = "description"
        case basePrice = "base_price"
        case imageURL = "image_url"
        case imageName = "image_name"
        case location
        case userID = "user_id"
        case status
        case seller = "User"
    }
}

struct SHOrderBuyer: Codable {
    let id: Int
    let fullName, email, phoneNumber, address: String
    let city: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phoneNumber = "phone_number"
        case address, city
    }
}

struct SHOrderSeller: Codable {
    let id: Int
    let fullName, email, phoneNumber, address: String
    let city: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phoneNumber = "phone_number"
        case address, city
    }
}


struct SHPatchedOrderResponse: Codable {
    let id, productID, buyerID, price: Int
    let transactionDate, productName: String
    let basePrice: Int
    let imageProduct: String
    let status, createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case buyerID = "buyer_id"
        case price
        case transactionDate = "transaction_date"
        case productName = "product_name"
        case basePrice = "base_price"
        case imageProduct = "image_product"
        case status, createdAt, updatedAt
    }
}

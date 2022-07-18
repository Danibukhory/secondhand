//
//  SHBannerResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 17/07/22.
//

import Foundation

struct SHBannerResponse: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case createdAt, updatedAt
    }
}

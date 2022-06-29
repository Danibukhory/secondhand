//
//  SHDataResponse.swift
//  SecondHand
//
//  Created by Bagas Ilham on 29/06/22.
//

import Foundation

struct SHDataResponse<T>: Codable where T: Codable {
    let data: [T]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

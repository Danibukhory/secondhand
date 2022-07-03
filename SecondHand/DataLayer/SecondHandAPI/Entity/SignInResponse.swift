//
//  SignInResponse.swift
//  SecondHand
//
//  Created by Raden Dimas on 03/07/22.
//

import Foundation

struct SignInResponse: Codable {
    var id: Int? = 0
    var name: String? = ""
    var email: String? = ""
    var accessToken: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case accessToken = "access_token"
    }
    
    
}

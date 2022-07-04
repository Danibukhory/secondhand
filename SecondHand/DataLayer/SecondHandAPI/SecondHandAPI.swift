//
//  SecondHandAPI.swift
//  SecondHand
//
//  Created by Bagas Ilham on 28/06/22.
//

import Foundation
import Alamofire

struct SecondHandAPI {
    let baseUrl: String = "https://market-final-project.herokuapp.com/"
    let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvaG5kb2VAbWFpbC5jb20iLCJpYXQiOjE2NTY5Mjg0OTJ9.I0quR9tEyYK9FKIxWJrurgvez8zLIJCRH6B-4Sti37o"
    
    func getNotifications(
        _ completionHandler: @escaping ([SHNotificationResponse]?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "notification",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: [SHNotificationResponse].self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(String(describing: error))
            }
        }
    }
    
    func getBuyerProducts(
        _ completionHandler: @escaping ([SHBuyerProductResponse]?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "buyer/product",
            method: .get,
            headers: headers
        )
            .validate()
            .responseDecodable(of: [SHBuyerProductResponse].self) { (response) in
                switch response.result {
                case let .success(data):
                    completionHandler(data, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                    print(String(describing: error))
                }
            }
    }
    
    func getSellerProducts(
        _ completionHandler: @escaping ([SHSellerProductResponse]?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(baseUrl + "seller/product",
                   method: .get,
                   headers: headers
        )
            .validate()
            .responseDecodable(of: [SHSellerProductResponse].self) { (response) in
                switch response.result {
                case let .success(data):
                    completionHandler(data, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                    print(String(describing: error))
                }
            }
    }
    
    func getBuyerProductDetail(
        itemId: String,
        _ completionHandler: @escaping (SHBuyerProductResponse?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "buyer/product/\(itemId)",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHBuyerProductResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(String(describing: error))
            }
        }
    }
    
    func setNotificationAsRead(
        notificationId: String
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "notification/\(notificationId)",
            method: .patch,
            headers: headers
        )
        .validate()
        .response { (response) in
            switch response.result {
            case .success(nil):
                print("Success")
            case let .failure(error):
                print(String(describing: error))
            default:
                print("")
            }
        }
    }
}

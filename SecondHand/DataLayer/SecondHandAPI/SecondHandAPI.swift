//
//  SecondHandAPI.swift
//  SecondHand
//
//  Created by Bagas Ilham on 28/06/22.
//

import Foundation
import Alamofire

struct SecondHandAPI {
    static let shared = SecondHandAPI()
    let baseUrl: String = "https://market-final-project.herokuapp.com/"
    let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvaG5kb2VAbWFpbC5jb20iLCJpYXQiOjE2NTY5Mjg0OTJ9.I0quR9tEyYK9FKIxWJrurgvez8zLIJCRH6B-4Sti37o"
    
    enum notificationProductStatus: String {
        case accepted = "accepted"
        case bid = "bid"
        case declined = "declined"
        case create = "create"
    }
    
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

    func getSellerItemDetail(
        itemId: String,
        _ completionHandler: @escaping (SHSellerProductResponse?, AFError?) -> Void
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
        .responseDecodable(of: SHSellerProductResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(String(describing: error))
            }
        }
    }
    
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (SignInResponse?, AFError?) -> Void
    )   {
        
  
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: String] = [
            "email" : email,
            "password" : password
        ]
 
        AF.request(
            baseUrl + "auth/login",
            method: .post,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SignInResponse.self) { (response) in
//            debugPrint(response)
            switch response.result {
            case let .success(data):
                completion(data,nil)
            case let .failure(error):
                completion(nil,error)
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func signUp(
        username: String,
        email: String,
        password: String,
        completion: @escaping (SignUpResponse?, AFError?) -> Void
    ) {
        
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: String] = [
            "full_name": username,
            "email" : email,
            "password" : password,
            "phone_number":"",
            "address":"",
            "image":"",
            "city":"",
        ]
 
        AF.request(
            baseUrl + "auth/register",
            method: .post,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SignUpResponse.self) { (response) in
            debugPrint(response)
            switch response.result {
            case let .success(data):
                completion(data,nil)
            case let .failure(error):
                completion(nil,error)
                debugPrint(error.localizedDescription)
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
    
    func getProductCategories(
    _ completionHandler: @escaping ([SHCategoryResponse]?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "seller/category",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: [SHCategoryResponse].self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(String(describing: error))
            }
        }
    }
    
    func patchSellerProductStatus(
        to status: notificationProductStatus,
        productId : String
    ) {
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = [
            "status" : status.rawValue
        ]
        AF.request(
            baseUrl + "seller/category/\(productId)",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .resume()
    }
}

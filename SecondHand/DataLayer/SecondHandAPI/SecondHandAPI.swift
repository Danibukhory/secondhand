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
    let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvaG5kb2VAbWFpbC5jb20iLCJpYXQiOjE2NTY0ODczNzh9.NSe3O_3zwRw7YxDjn9vmsBDzahvEWLEDMZ8dx1LN_H4"
    
    
    
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
    
    func postProductAsSeller(with name: String, description desc: String, basePrice price: Int, category catg: Int, location loc: String, productPicture image: UIImage) {
           let requestUrl = "seller/product"
           
           guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
               
           let headers: HTTPHeaders = [
               "access_token" : accessToken,
               "Content-Type" : "multipart/form-data",
           ]
           
           AF.upload(multipartFormData: { (multiPartFormData) in
               multiPartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
               multiPartFormData.append(desc.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "description")
               multiPartFormData.append("\(price)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "base_price")
               multiPartFormData.append("\(catg)".description.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_ids")
               multiPartFormData.append(loc.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "location")
               multiPartFormData.append(imageData, withName: "image", fileName: "\(name).jpg", mimeType: "image/jpeg")
               
           }, to: baseUrl + requestUrl, headers: headers)
           .uploadProgress(queue: .main) { progress in
               print("Upload Progress: \(progress.fractionCompleted)")
           }
           .responseJSON { data in
               print(data.debugDescription)
           }
       }
       
       func putAccountDetail(with name: String, city cty: String, phoneNumber phone: Int, address add: String, accountPicture image: UIImage) {
           let requestUrl = "auth/user"
           
           guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
               
           let headers: HTTPHeaders = [
               "access_token" : accessToken,
               "Content-Type" : "multipart/form-data",
           ]
           
           AF.upload(multipartFormData: { (multiPartFormData) in
               multiPartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "full_name")
               multiPartFormData.append(add.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "address")
               multiPartFormData.append("\(phone)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "phone_number")
               multiPartFormData.append(cty.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "city")
               multiPartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
               multiPartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "password")
               multiPartFormData.append(imageData, withName: "image", fileName: "\(name).jpg", mimeType: "image/jpeg")

           }, to: baseUrl + requestUrl, method: .put, headers: headers)
           .uploadProgress(queue: .main) { progress in
               print("Upload Progress: \(progress.fractionCompleted)")
           }
           .responseJSON { data in
               print(data.debugDescription)
           }
       }
       
       func postBuyerOrder(id itemID: Int, bidPrice price: Int) {
           let requestUrl = "buyer/order"
                       
           let headers: HTTPHeaders = [
               "access_token" : accessToken,
               "Content-Type" : "application/json",
           ]
           
           let parameter: [String: Any] = [
               "product_id": itemID,
               "bid_price":  price
           ]
       
           AF.request(baseUrl + requestUrl, method: .post, parameters: parameter, headers: headers)
               .responseDecodable { (response: AFDataResponse<Data>) in
                   switch response.result{
                   case .success(let value):
                       print(value.debugDescription)
                   case .failure(let value):
                       print(value.errorDescription)
                   }
           }
       }
    
}

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
    var accessToken: String? = UserDefaults.standard.string(forKey: "accessToken")
    
    enum ProductStatus: String {
        case accepted = "accepted"
        case bid = "bid"
        case declined = "declined"
        case create = "create"
    }
    
    func getNotifications(
        _ completionHandler: @escaping ([SHNotificationResponse]?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else {
            completionHandler(nil, nil)
            return
        }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
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
        AF.request(
            baseUrl + "buyer/product",
            method: .get
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
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "seller/product",
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
        _ completionHandler: @escaping (SHBuyerProductDetailResponse?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "buyer/product/\(itemId)",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHBuyerProductDetailResponse.self) { (response) in
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
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
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
        _ completionHandler: @escaping (SHUserResponse?, AFError?) -> Void
    )   {
        let parameters: [String: String] = [
            "email" : email,
            "password" : password
        ]
 
        AF.request(
            baseUrl + "auth/login",
            method: .post,
            parameters: parameters
        )
        .validate()
        .responseDecodable(of: SignInResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                if let _id = data.id, let token = data.accessToken {
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    getUserById(userId: _id, _accessToken: token) { result, error in
                        guard let _result = result else { return }
                        completionHandler(_result, nil)
                    }
                }
            case let .failure(error):
                completionHandler(nil,error)
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getUserById(
        userId: Int,
        _accessToken: String,
        _ completionHandler: @escaping (SHUserResponse?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "auth/user",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHUserResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    func signUp(
        username: String,
        email: String,
        password: String,
        completion: @escaping (SignUpResponse?, AFError?) -> Void
    ) {
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
            parameters: parameters
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
    
    func getUserDetails(
        _ completionHandler: @escaping (SHUserResponse?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
        ]
        AF.request(
            baseUrl + "auth/user",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHUserResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(String(describing: error))
            }
        }
    }

    func postProductAsSeller(
        with name: String,
        description desc: String,
        basePrice price: Int,
        category catg: Int,
        location loc: String,
        productPicture image: UIImage,
        _ completionHandler: @escaping (AFDataResponse<Data>) -> Void
    ) {
        let requestUrl = "seller/product"
        guard let _accessToken = accessToken,
              let imageData = image.jpegData(compressionQuality: 0.3)
        else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "multipart/form-data",
        ]
        
        AF.upload(multipartFormData: { (multiPartFormData) in
            multiPartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
            multiPartFormData.append(desc.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "description")
            multiPartFormData.append("\(price)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "base_price")
            multiPartFormData.append("\(catg)".description.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_ids")
            multiPartFormData.append(loc.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "location")
            multiPartFormData.append(imageData, withName: "image", fileName: "\(name).jpg", mimeType: "image/jpeg")
            
        }, to: baseUrl + requestUrl, method: .post , headers: headers)
        .uploadProgress(queue: .main) { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            completionHandler(response)
        }
    }
    
    func putAccountDetail(
        with name: String,
        city cty: String,
        phoneNumber phone: Int,
        address add: String,
        accountPicture image: UIImage,
        _ completionHandler: @escaping (AFDataResponse<Data>) -> Void
    ) {
        let requestUrl = "auth/user"
        guard let _accessToken = accessToken,
              let imageData = image.jpegData(compressionQuality: 0.3)
        else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
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
        .responseDecodable { (response: AFDataResponse<Data>) in
            completionHandler(response)
        }
    }
       
    func postBuyerOrder(
        id itemID: Int,
        bidPrice price: Int,
        _ completionHandler: @escaping (AFDataResponse<Data?>) -> Void
    ) {
        guard let _accessToken = accessToken else {
            print(">>> no access token")
            return
        }
        let requestUrl = "buyer/order"
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: Int] = [
            "product_id": itemID,
            "bid_price":  price
        ]
        
        AF.request(
            baseUrl + requestUrl,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .response { response in
            completionHandler(response)
        }
    }
    
    func getBuyerOrders(
        _ completionHandler: @escaping ([SHBuyerOrderResponse]?, AFError?) -> Void
    ) {
        let requestUrl = "buyer/order"
        guard let _accessToken = accessToken else { return }

        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + requestUrl,
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable (of: [SHBuyerOrderResponse].self) { (response) in
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
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
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
        AF.request(
            baseUrl + "seller/category",
            method: .get
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
        to status: ProductStatus,
        productId : String
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
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
        .responseDecodable(of: SHSellerProductUpdateResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                print("Updated product status to: \(data.status ?? "")")
            case let .failure(error):
                print(error.errorDescription ?? "Error occured")
            }
        }
    }
    
    func patchSellerOrderStatus(
        to status: ProductStatus,
        orderId: Int,
        _ completionHandler: @escaping (SHPatchedOrderResponse?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = [
            "status" : status.rawValue
        ]
        AF.request(
            baseUrl + "seller/order/\(orderId)",
            method: .patch,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHPatchedOrderResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
                print("Succesfully updated order status to: \(data.status)")
            case let .failure(error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    func getSellerOrders(
        _ completionHandler: @escaping ([SHSellerOrderResponse]?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "seller/order",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: [SHSellerOrderResponse].self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    func getSellerOrder(
        orderId: Int,
        _ completionHandler: @escaping (SHSellerOrderResponse?, AFError?) -> Void
    ) {
        guard let _accessToken = accessToken else { return }
        let headers: HTTPHeaders = [
            "access_token" : _accessToken,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        AF.request(
            baseUrl + "seller/order/\(orderId)",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SHSellerOrderResponse.self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    func getBanners(
        _ completionHandler: @escaping ([SHBannerResponse]?, AFError?) -> Void
    ) {
        AF.request(
            baseUrl + "seller/banner",
            method: .get
        )
        .validate()
        .responseDecodable(of: [SHBannerResponse].self) { (response) in
            switch response.result {
            case let .success(data):
                completionHandler(data, nil)
            case let .failure(error):
                completionHandler(nil, error)
                print(error)
            }
        }
    }
    
    mutating func renewAccessToken() {
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }
}

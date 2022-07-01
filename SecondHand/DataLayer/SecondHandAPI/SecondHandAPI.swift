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
    let accessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImRhZmZhQGdtYWlsLmNvbSIsImlhdCI6MTY1NjU5OTIzMn0._w6r5QGyJqU2LF4PZ1cJDHqne1j79GvGFjUMcA5ryiQ"
    
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
    
    func postProductAsSeller(with name: String, description desc: String, basePrice price: Int, category catg: Int, location loc: String, productPicture image: UIImage) {
        let requestUrl = "seller/product"
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
            
        let headers: HTTPHeaders = [
            "access_token" : accessToken,
            "Content-Type" : "multipart/form-data",
        ]
        
//        let params: [String:Any] = [
//            "category_ids" : catg
//        ]
        
        AF.upload(multipartFormData: { (multiPartFormData) in
            multiPartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
            multiPartFormData.append(desc.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "description")
            multiPartFormData.append("\(price)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "base_price")
            multiPartFormData.append("\(catg)".description.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_ids")
//            for (key,value) in params {
//                if let temp = value as? NSArray{
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        let value = "\(element)"
//                        multiPartFormData.append(value.data(using: .utf8, allowLossyConversion: false)!, withName: keyObj)
//                    })
//                }
//            }
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
}

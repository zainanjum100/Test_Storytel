//
//  ApiService.swift
//  Test_Storytel
//
//  Created by Zain Ul Abideen on 13/06/2021.
//

import Foundation
//Class to Network Service
class ApiService: NSObject {
    //static instance for this class
    static let instance = ApiService()
    //generic function to fetch data from server
    public func requestApi<T: Codable>(_ type: T.Type,method : HTTPMethod,url : String,completion: @escaping Completion<T>){
        //check if internet is online or not
        if !Reachability.isConnectedToNetwork() {
            //return an error indicating internet is offline
            completion(.failure(ServiceError.noInternetAvailable))
        }
        //request with url and endpoint
        var request = URLRequest(url: URL(string: (BASE_URL + url))!)
        //request method
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                //print data in case of debugging
                print(data.prettyPrintedJSONString ?? "")
                do {
                    let decoder = JSONDecoder()
                    //check response code
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.status?.responseType {
                        //if response code is between 200-300
                        case .success:
                            let JSON = try decoder.decode(type , from: data)
                            completion(.success(JSON))
                            //response code is not between 200-300
                        default:
                            completion(.failure(ServiceError.custom("Error code: \(String(describing: httpResponse.status))")))
                        }
                    }
                } catch let err {
                    //json decoding error
                    completion(.failure(ServiceError.custom(err.localizedDescription)))
                }
            }
            //resume urlsession
        }.resume()
        
    }
}

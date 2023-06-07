//
//  APIManager.swift
//  MVVM iOS Shopping App
//
//  Created by Cumulations on 06/06/23.
//

import UIKit


enum DataError : Error {
    case invalidResponse
    case invaildURL
    case invaildDataError
    case network(Error?)
}

typealias Handler = (Result<[Product], DataError>) -> Void

//singleton class  -> object can be created outside the class
//Singleton class  -> object cannot be created outside the class
//final class -> if its a final class then inheritance cannot be possible

//Singleton Class
final class APIManager{
    static let shared = APIManager()
     
    private init() {}
    
    func fetchProducts(completion :  @escaping Handler ){
        guard let url = URL(string: Constant.API.productURL)
        else {
            return
        }
        // background run
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invaildDataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 209 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            // decode -> throws so we must use do and catch block to handle if any error occurs
            do {
                // JSONDecoder converts the data to MODEL 
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}

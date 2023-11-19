//
//  NetworkManager.swift
//  HW-3.2-DY-New
//
//  Created by Denis Yarets on 15/11/2023.
//

import Foundation
import Alamofire

enum NetworkErrors: Error {
    case noData
    case decodeError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
}

extension NetworkManager {
    
    func fetchData<T: Decodable>(type: T.Type, url: URL, completionHandler: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completionHandler(.failure(NetworkErrors.noData))
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(type))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkErrors.decodeError))
                }
            }
            
        }.resume()
    }
    
    func fetchDataAFArray<T: ConvertibleFromJSONDictionary>(type: T.Type, url: URL, completionHandler: @escaping ([T]) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                        completionHandler(T.convertArray(from: json))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func postFruit(_ fruit: Fruit, completionHandler: @escaping (Fruit) -> ()) {
        AF.request(Links.postRequest.url, method: .post, parameters: fruit)
            .validate()
            .responseDecodable(of: FruitAdapter.self) { response in
                switch response.result {
                case .success(let fruitAdapter):
                    let fruit = Fruit.convertAdapter(from: fruitAdapter)
                    completionHandler(fruit)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}

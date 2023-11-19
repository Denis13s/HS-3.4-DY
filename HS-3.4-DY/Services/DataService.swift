//
//  DataService.swift
//  HW-3.2-DY
//
//  Created by Denis Yarets on 11/11/2023.
//

import Foundation

protocol DataServiceDelegate {
    func didGetData()
}

final class DataService {
    
    static let shared = DataService()
    
    private (set) var fruits = [Fruit]()
    
    var delegate: DataServiceDelegate?
    
    private init() {
        getJSONData()
    }
}

extension DataService {
    
    func getJSONData() {
        guard let url = URL(string: "https://www.fruityvice.com/api/fruit/all") else {
            print("1 - Unable to create url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("2 - " + (error?.localizedDescription ?? "Unable to create data"))
                return
            }
            
            // SHould be dispatch or not?
            do {
                let fruits = try JSONDecoder().decode([Fruit].self, from: data)
                self.fruits = fruits
                self.delegate?.didGetData()
            } catch {
                print("3 - " + error.localizedDescription)
            }
        }.resume()
    }
    
}

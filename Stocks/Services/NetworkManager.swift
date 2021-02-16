//
//  NetworkManager.swift
//  Stocks
//
//  Created by Vladimir Stepanchikov on 31.01.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let token = "pk_1f7ec74e06e048408a14de1eceeb3ae8"
    private let url = "https://cloud.iexapis.com/stable/stock/"
    private let urlLogo = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/"
    
    private init() {}
    
    func requestQuote(for symbol: String,
                      completion: @escaping (_ stock: Stock) -> Void) {
        
        guard let urlQuote = URL(string: "\(url)\(symbol)/quote?token=\(token)")
        else { return }
        
        let dataTask = URLSession.shared.dataTask(with: urlQuote) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self.parseQuote(from: data, completion: { stock in
                    completion(stock)
                })
            } else {
                print("Network error!")
            }
        }
        dataTask.resume()
    }
    
    private func parseQuote(from data: Data, completion: @escaping (_ stock: Stock) -> Void) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companySymbol = json["symbol"] as? String,
                let companyName = json["companyName"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double else { return print("Invalid JSON") }
            
            let companyLogo = "\(urlLogo)\(companySymbol).png"
            
            let stock = Stock(companySymbol: companySymbol,
                              companyName: companyName,
                              price: price,
                              priceChange: priceChange,
                              imageData: ImageManager.shared.getImageData(from: companyLogo))
            completion(stock)
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }

}

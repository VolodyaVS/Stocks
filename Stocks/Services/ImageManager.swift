//
//  ImageManager.swift
//  Stocks
//
//  Created by Vladimir Stepanchikov on 31.01.2021.
//

import Foundation

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func getImageData(from url: String) -> Data {
        guard let imageURL = URL(string: url) else { return Data() }
        guard let imageData = try? Data(contentsOf: imageURL) else { return Data() }
        
        return imageData
    }
}

//
//  Request.swift
//  Tinkoff Chat
//
//  Created by Андрей on 29.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class PhotosRequest: IRequest {
    fileprivate var command: String {
        assertionFailure("❌ Should use a subclass of PhtotoRequest ")
        return ""
    }
    
    private var limitString: String {
        return "&per_page=\(limit)"
    }
    
    private var baseUrl: String = "https://pixabay.com/api/?key=5490863-426994b89badd90c212d949e0"
    private var limit: Int
    private var type = "&image_type=photo&pretty=true"
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + command + type + limitString
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init(limit: Int = 200) {
        self.limit = limit
    }
}

class MenRequest: PhotosRequest {
    override var command: String { return "&q=men" }
}

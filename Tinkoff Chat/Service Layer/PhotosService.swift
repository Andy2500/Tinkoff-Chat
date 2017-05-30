//
//  PhotoService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 29.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

protocol IPhotosService {
    func loadPhotos(completionHandler: @escaping ([PhotoApiModel]?, String?) -> Void)
}

class PhotosService: IPhotosService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadPhotos(completionHandler: @escaping ([PhotoApiModel]?, String?) -> Void) {
        let requestConfig: RequestConfig<[PhotoApiModel]> = RequestsFactory.PhotosRequests.photosConfig()
        
        requestSender.send(config: requestConfig) { (result: Result<[PhotoApiModel]>) in
            switch result {
            case .Success(let tracks):
                completionHandler(tracks, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
        
    }
}

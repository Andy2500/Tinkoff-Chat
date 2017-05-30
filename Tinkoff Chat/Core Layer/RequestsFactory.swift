//
//  RequestsFactory.swift
//  Tinkoff Chat
//
//  Created by Андрей on 29.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct PhotosRequests {
        static func photosConfig() -> RequestConfig<[PhotoApiModel]> {
            return RequestConfig<[PhotoApiModel]>(request:MenRequest(), parser:
                PhotosParser())
        }
    }
}

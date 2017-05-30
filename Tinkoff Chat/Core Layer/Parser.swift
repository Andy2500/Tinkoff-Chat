//
//  File.swift
//  Tinkoff Chat
//
//  Created by Андрей on 29.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation
import UIKit

class Parser<T> {
    func parse(data: Data) -> T? { return nil }
}

enum PhotoRecordState {
    case New, Downloaded, Failed
}

struct PhotoApiModel {
    let previewUrl: String
    var state:PhotoRecordState
    var image:UIImage
}

class PhotosParser: Parser<[PhotoApiModel]> {
    override func parse(data: Data) -> [PhotoApiModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String : Any]] else {
                    return nil
            }

            var apps: [PhotoApiModel] = []
            
            for photoObject in hits {
                guard let previewURL = photoObject["previewURL"] as? String else { continue }
                apps.append(PhotoApiModel(previewUrl: previewURL, state: PhotoRecordState.New, image:UIImage(named: "Placeholder")!))
            }
            
            return apps
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}

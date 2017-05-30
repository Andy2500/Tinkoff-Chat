//
//  File.swift
//  Tinkoff Chat
//
//  Created by Андрей on 29.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader: Operation {
    
    var photoRecord: PhotoApiModel
    
    init(photoRecord: PhotoApiModel) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }

        guard let url = URL(string: self.photoRecord.previewUrl) else {
            return
        }
        
        let imageData = NSData(contentsOf: url)
        
        if self.isCancelled {
            return
        }
        
        if (imageData?.length)! > 0 {
            self.photoRecord.image = UIImage(data:imageData! as Data)!
            self.photoRecord.state = .Downloaded
        }
    }
}

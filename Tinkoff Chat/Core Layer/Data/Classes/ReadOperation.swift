//
//  ReadOperation.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class ReadOperation: Operation {
    var delegate: OperationDelegate?
    
    override func start() {
        let fileSystem = FileSystem()
        let readed = fileSystem.readDictionary()
        delegate?.readOperationCompleted(dictionary: readed.0, error: readed.1)
    }
}

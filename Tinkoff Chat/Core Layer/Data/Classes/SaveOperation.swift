//
//  SaveOperation.swift
//  Tinkoff Chat
//
//  Created by Андрей on 03.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class SaveOperation: Operation {
    
    var delegate: OperationDelegate?
    
    var dictionary: Dictionary<String, Any>?

    init(_ withDictionary: Dictionary<String, Any>?){
        if withDictionary != nil {
            self.dictionary = withDictionary
        }
    }
    
    override func start() {
        let fileSystem = FileSystem()
        let saved = fileSystem.saveDictionary(dictionary: dictionary!)
        self.delegate?.saveOperationCompleted(result: saved.0, error: saved.1)
    }
}

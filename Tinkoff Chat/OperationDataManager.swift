//
//  OperationDataManager.swift
//  Tinkoff Chat
//
//  Created by Андрей on 04.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class OperationDataManager: NSObject {
    
    var operation: SaveOperation!
    
    init(withVC: ViewController, withDictionary: Dictionary<String, Any>?, withType: Int) {
        self.operation = SaveOperation(withVC: withVC, withDictionary: withDictionary, withType: withType)
    }
    
    func saveData(){
        operation.start()
    }
    
    func readData(){
        operation.start()
    }
}

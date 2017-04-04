//
//  GCDDataManager.swift
//  Tinkoff Chat
//
//  Created by Андрей on 04.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject {
    
    let queue = DispatchQueue(label: "com.apple.saveQueue", qos: .userInteractive, target: nil)
    var dictionary: Dictionary<String, Any>?
    
    weak var VC: ViewController!
    
    init(withVC: ViewController!, withDictionary: Dictionary<String, Any>?) {
        self.VC = withVC
        self.dictionary = withDictionary
    }
    
    func saveData(completeHandler: @escaping (Bool, GCDDataManager)->Void){
        queue.sync{[weak self] in
            if let this = self {
                let manager = MyFileManager.getManager()
                let saved = manager.saveDictionary(dictionary: this.dictionary!)
                DispatchQueue.main.async {
                    completeHandler(saved, this)
                }
            }
        }
    }
}

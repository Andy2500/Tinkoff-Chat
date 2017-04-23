//
//  GCDDataService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 04.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class GCDDataService: NSObject, DataService {
    
    let queue = DispatchQueue(label: "com.apple.saveQueue", qos: .userInteractive, target: nil)

    weak var fileService: FileSystem?
    var delegate: DataServiceDelegate?
    
    override init() {
        self.fileService = FileSystem()
    }
    
    func saveData(_ dict: Dictionary<String, Any>?){
        if let dictionary = dict {
            queue.sync{[weak self] in
                if let this = self {
                    let saved = this.fileService?.saveDictionary(dictionary: dictionary)
                    DispatchQueue.main.async {
                        if let completed = saved?.0 {
                            if completed {
                                this.delegate?.savingCompleted()
                            } else {
                                if let error = saved?.1 {
                                    this.delegate?.savingFinishedwithError(error)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.delegate?.savingFinishedwithError(NSError(domain: "Empty Dictionary", code: 0, userInfo: nil))
        }
    }
    
    func readData(){
        queue.sync{[weak self] in
            if let this = self {
                let dict = this.fileService?.readDictionary();
                DispatchQueue.main.async {
                    if let dictionary = dict?.0{
                        this.delegate?.readingCompleted(dictionary)
                    } else {
                        if let error = dict?.1{
                            this.delegate?.readingFinishedwithError(error)
                        } else {
                            this.delegate?.readingCompleted(nil)
                        }
                    }
                }
            }
        }
    }
}

//
//  OperationDataManager.swift
//  Tinkoff Chat
//
//  Created by Андрей on 04.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class OperationDataService: NSObject, DataService, OperationDelegate {
    
    var delegate: DataServiceDelegate?
    
    func saveData(_ dict: Dictionary<String, Any>?){
        if let dictionary = dict{
            let operation = SaveOperation(dictionary)
            operation.delegate = self
            OperationQueue.main.addOperation(operation)
        } else {

        }
    }
    
    func readData(){
        let operation = ReadOperation()
        operation.delegate = self
        OperationQueue.main.addOperation(operation)
    }
    
    func readOperationCompleted(dictionary: Dictionary<String, Any>?, error: Error?){
        if let dictionary = dictionary{
            self.delegate?.readingCompleted(dictionary)
        } else {
            if let error = error{
                self.delegate?.readingFinishedwithError(error)
            } else {
                self.delegate?.readingCompleted(nil)
            }
        }
    }
    
    func saveOperationCompleted(result: Bool,error: Error?){
            if result {
                self.delegate?.savingCompleted()
            } else {
                if let error = error {
                    self.delegate?.savingFinishedwithError(error)
                }
            }
    }
}

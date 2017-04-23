//
//  IModel.swift
//  Tinkoff Chat
//
//  Created by Андрей on 23.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol SModel {
    func save(_ dictionary: Dictionary<String, Any>?, type: Bool)
}

protocol RModel {
    func read(type: Bool)
}

class IOModel: NSObject, DataServiceDelegate, RModel, SModel {
    private var firstDataService: DataService?
    private var secondDataService: DataService?
    var delegate:IOModelDelegate?
    
    init(_ fDS: DataService?,_ sDS: DataService?) {
        self.firstDataService = fDS
        self.secondDataService = sDS
        super.init()
        self.firstDataService?.delegate = self
        self.secondDataService?.delegate = self
    }
    
    func savingCompleted(){
        delegate?.savingCompleted()
    }
    
    func readingCompleted(_ dictionary: Dictionary<String, Any>?){
        delegate?.readingCompleted(dictionary)
    }
    
    func savingFinishedwithError(_ error: Error){
        delegate?.savingFinishedwithError(error)
    }
    
    func readingFinishedwithError(_ error: Error){
        delegate?.readingFinishedwithError(error)
    }
    
    func save(_ dictionary: Dictionary<String, Any>?, type: Bool){
        if type {
            self.firstDataService?.saveData(dictionary)
        } else {
           self.secondDataService?.saveData(dictionary)
        }
    }
    
    func read(type: Bool){
        if type {
            self.firstDataService?.readData()
        } else {
            self.secondDataService?.readData()
        }
    }
}

protocol IOModelDelegate {
    func savingCompleted()
    func readingCompleted(_ dictionary: Dictionary<String, Any>?)
    
    func savingFinishedwithError(_ error: Error)
    func readingFinishedwithError(_ error: Error)
}

//
//  DataServiceDelegate.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol DataServiceDelegate {
    
    func savingCompleted()
    func readingCompleted(_ dictionary: Dictionary<String, Any>?)
    
    func savingFinishedwithError(_ error: Error)
    func readingFinishedwithError(_ error: Error)
}

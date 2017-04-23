//
//  OperationDelegate.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol OperationDelegate {
    func readOperationCompleted(dictionary: Dictionary<String, Any>?, error: Error?)
    func saveOperationCompleted(result: Bool,error: Error?)
}

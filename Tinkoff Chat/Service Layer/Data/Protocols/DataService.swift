//
//  DataService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol DataService {
    func saveData(_ dictionary: Dictionary<String, Any>?)
    func readData()

    var delegate: DataServiceDelegate?{ get set}
}

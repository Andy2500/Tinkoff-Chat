//
//  DataService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol DataUserService {
    func saveUser(_ dictionary: Dictionary<String, Any?>?)
    func readUser()

    var delegate: StorageServiceDelegate?{ get set}
}

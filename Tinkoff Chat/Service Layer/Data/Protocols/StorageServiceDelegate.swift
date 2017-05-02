//
//  DataServiceDelegate.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol StorageServiceDelegate {
    func userSaved()
    func userLoaded(user: User?)
}

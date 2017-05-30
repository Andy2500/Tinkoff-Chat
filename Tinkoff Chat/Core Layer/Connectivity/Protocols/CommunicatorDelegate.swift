//
//  CommunicatorDelegate.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
        
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

//
//  CommunicationServiceDelegate.swift
//  Tinkoff Chat
//
//  Created by Андрей on 23.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol CommunicationServiceConversationDelegate {
    //discovering
    func didLostUser(userID: String)
    func didFoundUser(userID: String, userName: String?)
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

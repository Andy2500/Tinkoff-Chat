//
//  ICommunicationService.swift
//  Tinkoff Chat
//
//  Created by Андрей on 23.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol ICommunicationService {
    func sendMessage(text:String, toUser: String, handler: @escaping((Bool, Error?)->Void))
    
    var listDelegate: CommunicationServiceConversationDelegate?{get set}
    var viewDelegate: CommunicationServiceConversationDelegate?{get set}
    var myUserID: String?{get}
}

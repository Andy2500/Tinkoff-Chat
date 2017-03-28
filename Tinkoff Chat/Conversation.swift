//
//  ConversationCellConfiguration.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 28.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import Foundation

class Conversation:NSObject {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessages: Bool?
    var otherMessages: [Message] = []
    
    override init(){
        super.init()
    }
    
    init(name: String?, message: String?, date: Date?, online:Bool?, hasUnreadMessages: Bool?, otherMessages:[Message]?) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        
        if let other = otherMessages{
            self.otherMessages = other
        }
        
    }
}

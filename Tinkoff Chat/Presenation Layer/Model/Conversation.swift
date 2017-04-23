//
//  ConversationCellConfiguration.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 28.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import Foundation

class Conversation:NSObject {
    var userID: String?
    var name: String?
    var online: Bool?
    var hasUnreadMessages: Bool?
    var messages: [Message] = []
    
    override init(){
        super.init()
    }
    
    init(name: String?, online:Bool? = true, hasUnreadMessages: Bool? = false, messages:[Message]? = nil, userID: String?) {
        self.name = name
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.userID = userID
        
        if let other = messages{
            self.messages = other
        }
    }
    
    
}

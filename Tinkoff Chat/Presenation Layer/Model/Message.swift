//
//  Message.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 28.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text: String?
    var toUser: String?
    var fromUser: String?
    var date: Date?
    
    init(text: String, toUser: String, fromUser: String?, date: Date?) {
        self.text = text
        self.toUser = toUser
        self.fromUser = fromUser
        self.date = date
    }
}

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
    
    init(text: String) {
        self.text = text
    }
}

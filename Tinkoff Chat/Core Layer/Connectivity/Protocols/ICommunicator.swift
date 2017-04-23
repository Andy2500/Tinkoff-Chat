//
//  Communicator.swift
//  Tinkoff Chat
//
//  Created by Андрей on 22.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import Foundation

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, complectionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate?{get set}
    var online: Bool{get set}
}

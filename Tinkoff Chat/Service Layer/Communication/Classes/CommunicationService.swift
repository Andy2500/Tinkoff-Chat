//
//  CommunicatorService.swift
//  ConnectedColors
//
//  Created by Андрей on 06.04.17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class CommunicationService: NSObject, CommunicatorDelegate, ICommunicationService {

    var communicator: MultipeerCommunicator?
    var myUserID: String?{
        get{return communicator?.myPeerId.displayName}
    }
    
    var listDelegate: CommunicationServiceConversationDelegate?
    var viewDelegate: CommunicationServiceConversationDelegate?
    
    override init() {
        super.init()
        communicator = MultipeerCommunicator()
        communicator?.delegate = self
    }
    
    //discovering
    func didFoundUser(userID: String, userName: String?){
        self.listDelegate?.didFoundUser(userID: userID, userName: userName)
        self.viewDelegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String){
        self.viewDelegate?.didLostUser(userID: userID)
        self.listDelegate?.didLostUser(userID: userID)
    }
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String){
        self.viewDelegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
        self.listDelegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(text:String, toUser: String, handler: @escaping((Bool, Error?)->Void)){
        self.communicator?.sendMessage(string: text, to: toUser, complectionHandler: handler)
    }
}

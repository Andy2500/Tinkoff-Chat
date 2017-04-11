//
//  CommunicatorManager.swift
//  ConnectedColors
//
//  Created by Андрей on 06.04.17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

protocol CommunicationManagerConversationDelegate {
    
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

protocol CommunicationManagerConversationsListDelegate {
    
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
        
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

protocol CommunicationManagerConversationViewDelegate {
    
    //discovering
    func didLostUser(userID: String)
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String)
}

class CommunicatorManager: NSObject, CommunicatorDelegate {

    var communication: MultipeerCommunicator?
    var myUserID: String?{
        get{return communication?.myPeerId.displayName}
    }
    
    static var manager:CommunicatorManager?
    var listDelegate: CommunicationManagerConversationsListDelegate?
    var viewDelegate: CommunicationManagerConversationViewDelegate?
    
    static func getManager(withListDelegate: CommunicationManagerConversationsListDelegate? = nil, withViewDelegate: CommunicationManagerConversationViewDelegate? = nil) -> CommunicatorManager{
        if manager != nil {
            
            if withListDelegate != nil{
                manager?.listDelegate = withListDelegate
            }
            
            if withViewDelegate != nil{
                manager?.viewDelegate = withViewDelegate
            }
            return manager!
        } else {
            manager = CommunicatorManager()

            if withListDelegate != nil{
                manager?.listDelegate = withListDelegate
            }
            
            if withViewDelegate != nil{
                manager?.viewDelegate = withViewDelegate
            }
            
            return manager!
        }
    }
    
    override init() {
        super.init()
        communication = MultipeerCommunicator.getCommunicator()
        communication?.delegate = self
    }
    
    //discovering
    func didFoundUser(userID: String, userName: String?){
        self.listDelegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String){
        self.viewDelegate?.didLostUser(userID: userID)
        self.listDelegate?.didLostUser(userID: userID)
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error){
        
    }
    
    func failedToStartAdvertising(error: Error){
        
    }
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String){
        self.viewDelegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
        self.listDelegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(text:String, toUser: String, handler: @escaping((Bool, Error?)->Void)){
        self.communication?.sendMessage(string: text, to: toUser, complectionHandler: handler )
    }
}

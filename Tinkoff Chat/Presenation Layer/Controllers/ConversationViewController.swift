//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationServiceConversationDelegate{

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    
//    var conversation:Conversation = Conversation()
    var communicationService: ICommunicationService?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
//        conversation.hasUnreadMessages = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        if(conversation.online == false){
//            sendButton.isEnabled = false
//        }
//        
//        conversation.hasUnreadMessages = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return conversation.messages.count
        return 0
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if conversation.messages[indexPath.row].toUser != conversation.userID{
//            let fromCell = tableView.dequeueReusableCell(withIdentifier: "fromMessageCell", for: indexPath) as! MessageTableViewCell
//            fromCell.messageTextLabel.text = conversation.messages[indexPath.row].text
//            return fromCell
//        } else {
//            let toCell = tableView.dequeueReusableCell(withIdentifier: "toMessageCell", for: indexPath) as! MessageTableViewCell
//            toCell.messageTextLabel.text = conversation.messages[indexPath.row].text
//            return toCell
//        }
//    }
    
    //discovering
    func didLostUser(userID: String){
        DispatchQueue.main.async {[weak self] in
//            if(userID == self.conversation.userID){
//                self.sendButton.isEnabled = false
//            }
            
            let first = self?.sendButton.frame
            var frame = self?.sendButton.frame
            frame?.size.height = (self?.sendButton.frame.height)! * 1.15
            frame?.size.width = (self?.sendButton.frame.width)! * 1.15
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self?.sendButton.frame = frame!
                self?.sendButton.isEnabled = false
                
            }) { (true) in
                UIView.animate(withDuration: 0.25){
                    self?.sendButton.frame = first!
                }
            }
        
            
        }
    }
    
    func didFoundUser(userID: String, userName: String?){
        DispatchQueue.main.async { [weak self] in
//            if self?.conversation.userID == userID{
//                self?.sendButton.isEnabled = true
//            }
            
            let first = self?.sendButton.frame
            var frame = self?.sendButton.frame
            frame?.size.height = (self?.sendButton.frame.height)! * 1.15
            frame?.size.width = (self?.sendButton.frame.width)! * 1.15
            
            let color = UIColor.green
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self?.sendButton.frame = frame!
                self?.sendButton.titleLabel?.textColor = color
            }) { (true) in
                UIView.animate(withDuration: 0.25){
                    self?.sendButton.frame = first!
                }
            }
        }
    }
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String){
        DispatchQueue.main.async {
//            self.conversation.messages.append(Message(text: text, toUser: toUser, fromUser: fromUser, date: Date()))
//            self.tableView.reloadData()
//            self.tableView.scrollToRow(at: IndexPath(row: self.conversation.messages.count - 1, section: 0 ), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.frame.origin.y += keyboardSize.height
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.frame.origin.y -= keyboardSize.height
            self.view.frame.origin.y += keyboardSize.height
        }
    }
 
    @IBAction func sendButtonPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        
//        communicationService?.viewDelegate = self
//        communicationService?.sendMessage(text: messageTextField.text!, toUser: conversation.userID!){
//           [weak self] (result, error) in
//            if(result){
//                DispatchQueue.main.async {
//                    self?.conversation.messages.append(Message(text: (self?.messageTextField.text!)!,toUser: (self?.conversation.userID!)!, fromUser: self?.communicationService?.myUserID!, date: Date()))
//                    self?.messageTextField.text = ""
//                    self?.tableView.reloadData()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("nothing was sended")
//                }
//            }
//        }

    }
}

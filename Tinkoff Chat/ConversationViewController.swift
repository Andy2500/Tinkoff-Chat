//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationManagerConversationViewDelegate{
    
    var conversation:Conversation = Conversation()
    
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
        conversation.hasUnreadMessages = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if conversation.messages[indexPath.row].toUser == conversation.userID{
            let fromCell = tableView.dequeueReusableCell(withIdentifier: "fromMessageCell", for: indexPath) as! MessageTableViewCell
            fromCell.messageTextLabel.text = conversation.messages[indexPath.row].text
            return fromCell
        } else {
            let toCell = tableView.dequeueReusableCell(withIdentifier: "toMessageCell", for: indexPath) as! MessageTableViewCell
            toCell.messageTextLabel.text = conversation.messages[indexPath.row].text
            return toCell
        }
    }
    
    //discovering
    func didLostUser(userID: String){
        DispatchQueue.main.async {
            if(userID == self.conversation.userID){
                self.sendButton.isEnabled = false
            }
        }
    }
    
    //messages
    func didRecieveMessage(text:String, fromUser: String, toUser: String){
        DispatchQueue.main.async {
            self.conversation.messages.append(Message(text: text, toUser: toUser, fromUser: fromUser, date: Date()))
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.conversation.messages.count - 1, section: 0 ), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.frame.size.height -= keyboardSize.height
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.frame.size.height += keyboardSize.height
            self.view.frame.origin.y += keyboardSize.height
        }
    }
 
    @IBAction func sendButtonPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        CommunicatorManager.getManager().viewDelegate = self
        CommunicatorManager.getManager().sendMessage(text: messageTextField.text!, toUser: conversation.userID!){
           [weak self] (result, error) in
            if(result){
                DispatchQueue.main.async {
                    self?.conversation.messages.append(Message(text: (self?.messageTextField.text!)!,toUser: (self?.conversation.userID!)!, fromUser: CommunicatorManager.getManager().myUserID!, date: Date()))
                    self?.messageTextField.text = ""
                    self?.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    print("nothing was sended")
                }
            }
        }

    }
}

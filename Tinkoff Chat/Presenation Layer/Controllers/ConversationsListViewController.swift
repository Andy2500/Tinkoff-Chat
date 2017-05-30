//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationServiceConversationDelegate {
    
    var conversations:Array<Array<Conversation>>  = []
    var communicationService: ICommunicationService?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.communicationService = CommunicationService()
        self.communicationService?.listDelegate = self
        
        conversations.append([])
        conversations.append([])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        
        self.view.isUserInteractionEnabled = true
        let gR = SelfGestureRecognizer(target:self, action: nil)
        self.view.addGestureRecognizer(gR)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let conversation = conversations[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        
        cell.nameLabel.text = conversation.name
        
        if conversation.messages.count != 0{
            if let message = conversation.messages[conversation.messages.count - 1].text{
                cell.messageTextLabel.text = message
            }
        } else {
            cell.messageTextLabel.text = "No messages yet"
            cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        
        if conversation.messages.count != 0{
            if let date = conversation.messages[conversation.messages.count - 1].date{
                if date <= Date().addingTimeInterval(-86400){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM"
                    cell.dateLabel.text = formatter.string(from: date)
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    cell.dateLabel.text = formatter.string(from: date)
                }
            }
        }  else {
            cell.dateLabel.text = "Никогда"
        }
        
        if conversation.online! {
            cell.contentView.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 0, alpha: 0.1)
        }
        
        if conversation.hasUnreadMessages!{
            cell.messageTextLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "Offline"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showConversationSegue", sender: conversations[indexPath.section][indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cs = sender as? Conversation{
            segue.destination.navigationItem.title = cs.name
            if let vc = segue.destination as? ConversationViewController{
                vc.communicationService = self.communicationService
                vc.conversation = cs
                self.communicationService?.viewDelegate = vc
            }
        }
    }
    
    func didFoundUser(userID: String, userName: String?){
        DispatchQueue.main.async { [weak self] in
            if let conversation = self?.conversations[1].first(where: { $0.userID == userID }){
                self?.conversations[0].append(conversation)
                self?.conversations[1].remove(at: (self?.conversations[1].index(of: conversation)!)!)
                conversation.online = true
            } else if nil == self?.conversations[0].first(where: { $0.userID == userID }){
                self?.conversations[0].append(Conversation(name: userName, userID: userID))
            }
            
            self?.tableView.reloadData()

        }
    }
    
    func didLostUser(userID: String){
        DispatchQueue.main.async { [weak self] in
            if let conversation = self?.conversations[0].first(where: { $0.userID == userID }){
                self?.conversations[1].append(conversation)
                conversation.online = false
                self?.conversations[0].remove(at: (self?.conversations[1].index(of: conversation)!)!)
            }
            self?.tableView.reloadData()
        }
    }
    
    func didRecieveMessage(text:String, fromUser: String, toUser: String){
        DispatchQueue.main.async { [weak self] in
            if self?.communicationService?.viewDelegate == nil{
                if let conversation = self?.conversations[0].first(where: { $0.userID == fromUser }){
                    conversation.messages.append(Message(text: text, toUser: toUser, fromUser: fromUser, date: Date()))
                } else if let conversation = self?.conversations[0].first(where: { $0.userID == toUser }){
                    conversation.messages.append(Message(text: text, toUser: toUser, fromUser: fromUser, date: Date()))
                }
            }

            self?.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.communicationService?.viewDelegate = nil
        self.tableView.reloadData()
    }
}

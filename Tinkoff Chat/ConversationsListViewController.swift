//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationManagerConversationsListDelegate {
    
    var conversations:Array<Array<Conversation>>  = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommunicatorManager.getManager().listDelegate = self
        
        /*
         let text = "Lorem Ipsum - это текст-\"рыба\", часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной \"рыбой\" для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum."
         
         conversations.append([])
         conversations.append([])
         
         conversations[0].append(Conversation.init(name: "Alex", message: text, date: Date(), online: true, hasUnreadMessages: false, otherMessages: [Message.init(text: "Да?"), Message.init(text: "\"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...\"")]))
         conversations[0].append(Conversation.init(name: "Andrey", message: "\"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...\"", date: Date().addingTimeInterval(-86401), online: true, hasUnreadMessages: true, otherMessages: []))
         conversations[0].append(Conversation.init(name: "Artemkiss", message: "Привет!", date: Date().addingTimeInterval(-1000), online: true, hasUnreadMessages: true, otherMessages: []))
         conversations[0].append(Conversation.init(name: "Магазин одежды", message: "Скидки, скидки, скидки!", date: Date(), online: true, hasUnreadMessages: false, otherMessages: []))
         conversations[1].append(Conversation.init(name: "Oleg", message: nil, date: Date(), online: false, hasUnreadMessages: false, otherMessages: []))
         conversations[1].append(Conversation.init(name: "Другой магазин одежды", message: "Скидки, скидки, скидки!", date: Date().addingTimeInterval(-1000000), online: false, hasUnreadMessages: true, otherMessages: []))
         conversations[1].append(Conversation.init(name: "Очередной спамер", message: "Купите это и купите то", date: Date().addingTimeInterval(-1000000), online: false, hasUnreadMessages: false, otherMessages: []))
         */
        conversations.append([])
        conversations.append([])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
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
                CommunicatorManager.getManager().viewDelegate = vc
                vc.conversation = cs
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
            if CommunicatorManager.getManager().viewDelegate == nil{
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
        CommunicatorManager.getManager().viewDelegate = nil
        self.tableView.reloadData()
    }
}

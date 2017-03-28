//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var conversations:Array<Array<Conversation>>  = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if let message = conversation.message{
            cell.messageTextLabel.text = message
        } else {
            cell.messageTextLabel.text = "No messages yet"
            cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        if (conversation.date != nil){
            if conversation.date! <= Date().addingTimeInterval(-86400){
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM"
                cell.dateLabel.text = formatter.string(from: conversation.date!)
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.dateLabel.text = formatter.string(from: conversation.date!)
            }
        } else {
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
                vc.conversation = cs
            }
            

        }
     }
     
}

//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 27.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var conversation:Conversation = Conversation()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.otherMessages.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "fromMessageCell", for: indexPath) as! MessageTableViewCell
            if(indexPath.row == 0){
                cell.messageTextLabel.text = conversation.message
            } else {
                cell.messageTextLabel.text = conversation.otherMessages[indexPath.row - 1].text
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toMessageCell", for: indexPath) as! MessageTableViewCell
            cell.messageTextLabel.text = conversation.otherMessages[indexPath.row - 1].text
            return cell
        }
    }
}

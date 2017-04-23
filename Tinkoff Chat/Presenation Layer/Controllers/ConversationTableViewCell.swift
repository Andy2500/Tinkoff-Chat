//
//  ConversationTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 28.03.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell{

    @IBOutlet var messageTextLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

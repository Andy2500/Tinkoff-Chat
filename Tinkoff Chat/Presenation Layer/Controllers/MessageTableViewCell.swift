//
//  MessageTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 28.03.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var messageView: UIView!
    @IBOutlet var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.layer.borderWidth = 5.0
        messageView.layer.cornerRadius = 10
        messageView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

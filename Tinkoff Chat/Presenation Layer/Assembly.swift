//
//  Assembly.swift
//  Tinkoff Chat
//
//  Created by Андрей on 23.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class Assembly: NSObject {
    
    func conversationListVC() -> ConversationsListViewController {
        let service = CommunicationService()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ConversationsListViewController
        vc.communicationService = service
        service.listDelegate = vc
        return vc
    }

    
    // MARK: - PRIVATE SECTION
    

}

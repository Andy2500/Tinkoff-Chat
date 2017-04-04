//
//  SaveOperation.swift
//  Tinkoff Chat
//
//  Created by Андрей on 03.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class SaveOperation: Operation {
    
    weak var vc: ViewController!
    var dictionary: Dictionary<String, Any>?
    var type = 0
    
    init(withVC: ViewController, withDictionary: Dictionary<String, Any>?, withType: Int){
        self.vc = withVC
        
        if withDictionary != nil {
            self.dictionary = withDictionary
        }
        
        self.type = withType
    }
    
    override func start() {
        
        if type == 0{
            let manager = MyFileManager.getManager()
            let alert = UIAlertController(title: "Сохранение", message: "", preferredStyle: .alert)
            
            if (manager.saveDictionary(dictionary: dictionary!)){
                let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(actionOk)
            } else {
                let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
                let actionReload = UIAlertAction(title: "Повторить", style: .default, handler:{[weak self] (alert) in self?.start()} )
                alert.addAction(actionOk)
                alert.addAction(actionReload)
            }
            
            vc?.present(alert, animated: true, completion: nil)
            vc?.savingActivityIndicatorView.stopAnimating()
            vc?.saveGCDButton.isEnabled = false
            vc?.saveOperationButton.isEnabled = false
        } else {
            let manager = MyFileManager.getManager()
            if let dictionary = manager.readDictionary(){
                vc?.reloadData(dictionary: dictionary)
            } else {
                vc?.savingActivityIndicatorView.stopAnimating()
            }
        }
    }
}

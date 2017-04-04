//
//  FileManager.swift
//  Tinkoff Chat
//
//  Created by Андрей on 04.04.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class MyFileManager: NSObject {
    //Поскольку мы всегда считываем все данные из файла, можно записывать данные в один файл
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/userInfo.plist"
    
    static var manager: MyFileManager = MyFileManager()
    
    static func getManager()->MyFileManager{
        return manager
    }
    
    func saveDictionary(dictionary: Dictionary<String, Any>)->Bool{
        do {
            let data2 = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            let url = URL(fileURLWithPath: path)
            try data2.write(to: url)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func readDictionary()->Dictionary<String, Any>?{
        if let data = NSData(contentsOfFile: path) {
            do {
                let object = try PropertyListSerialization.propertyList(from: data as Data, options: .mutableContainersAndLeaves, format: nil)
                let diciton = object as! Dictionary<String, Any>
                return diciton
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

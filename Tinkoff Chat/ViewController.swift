//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Андрей on 07.03.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var aboutTextView: UITextView!
    
    let tap = UITapGestureRecognizer()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        print(self.description)
        
        self.imagePicker.delegate = self
        self.loginTextField.delegate = self
        
        tap.addTarget(self, action: #selector(viewDidTapped))
    }
    
    func viewDidTapped(){
        aboutTextView.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        print(self.description)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        print(self.description)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
        print(self.description)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        print(self.description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorButtonPressed(_ sender: Any) {
        if let button = sender as? UIButton{
            colorLabel.textColor = button.backgroundColor
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


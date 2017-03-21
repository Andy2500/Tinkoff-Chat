//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Андрей on 07.03.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        for subview in view.subviews { print(subview) }
        
        userImageView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTappend)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        print("doneButtonPressed")
    }
    
    func endEditing(){
        loginTextField.endEditing(true)
        aboutTextView.endEditing(true)
    }
    
    func imageTappend(){
        let choosingController = UIAlertController(title: "Загрузить фото из:", message: nil, preferredStyle: .actionSheet);
        
        let photoAction = UIAlertAction(title: "Камера", style: .default){(alert) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let libraryAction = UIAlertAction(title: "Фотопленка", style: .default){(alert) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        choosingController.addAction(photoAction)
        choosingController.addAction(libraryAction)
        
        if(self.userImageView.image != UIImage(named: "placeholder-user")){
            let deleteAction = UIAlertAction(title: "Удалить фотографию", style: .default){ (alert) in
                self.userImageView.image = UIImage(named: "placeholder-user")
            }
            choosingController.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        choosingController.addAction(cancelAction)
        self.present(choosingController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        for subview in view.subviews { print(subview) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        for subview in view.subviews { print(subview) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
        for subview in view.subviews { print(subview) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        for subview in view.subviews { print(subview) }
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        let cancelController = UIAlertController(title: "Фото не было выбрано", message: nil, preferredStyle: .alert);
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel)
        cancelController.addAction(cancelAction)
        self.present(cancelController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}


//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 07.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, IOModelDelegate{
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var savingActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationButton: UIButton!
    
    var lastPressedColorButton = 0 //0-последней не нажата ни одна кнопка, 1 - черный, 2 - красный, 3 - зеленый, 3 - синий, 4 - розовый
    var lastTypeOfSaving = true // true - Operation, false - GCD

    var ioModel: IOModel?
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTappend)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonPressed))
        
        self.savingActivityIndicatorView.hidesWhenStopped = true
        self.savingActivityIndicatorView.startAnimating()
        
        
    }
    
    func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.makeSaveButtonsEnabled()
    }
    
    func endEditing(){
        loginTextField.endEditing(true)
        aboutTextView.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.makeSaveButtonsEnabled()
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
    
    
    @IBAction func loginChanged(_ sender: Any) {
        self.makeSaveButtonsEnabled()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorButtonPressed(_ sender: Any) {
        if let button = sender as? UIButton{
            if button.backgroundColor != colorLabel.textColor {
                colorLabel.textColor = button.backgroundColor
                self.makeSaveButtonsEnabled()
                
                lastPressedColorButton = button.tag
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if sender.restorationIdentifier == "Operation" {
            self.save(type: true)
        } else if sender.restorationIdentifier == "GCD" {
            self.save(type: false)
        }
    }
    
    func save(type: Bool){
        lastTypeOfSaving = type
        savingActivityIndicatorView.startAnimating()
        let dictionary: [String : Any] = ["userName":loginTextField.text!, "aboutInfo": aboutTextView.text, "photo": UIImagePNGRepresentation(userImageView.image!)!, "color": lastPressedColorButton]
        
        ioModel?.save(dictionary, type: type)

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
            self.makeSaveButtonsEnabled()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func makeSaveButtonsEnabled(){
        saveGCDButton.isEnabled = true
        saveOperationButton.isEnabled = true
    }
    
    func readingCompleted(_ dictionary: Dictionary<String, Any>?){
        if let nnDictionary = dictionary{
            self.aboutTextView.text = nnDictionary["aboutInfo"] as! String
            self.loginTextField.text = (nnDictionary["userName"] as! String)
            self.userImageView.image = UIImage(data: nnDictionary["photo"] as! Data)
            
            switch nnDictionary["color"] as! Int {
            case 1:
                self.colorLabel.textColor = UIColor.black
            case 2:
                self.colorLabel.textColor = UIColor.red
            case 3:
                self.colorLabel.textColor = UIColor.green
            case 4:
                self.colorLabel.textColor = UIColor.blue
            case 5:
                self.colorLabel.textColor = UIColor.magenta
            default:
                break
            }
        }
        
        self.savingActivityIndicatorView.stopAnimating()
    }
    
    func savingCompleted(){
        let alert = UIAlertController(title: "Сохранение", message: "", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(actionOk)

        
        self.saveGCDButton.isEnabled = false
        self.saveOperationButton.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }

    func savingFinishedwithError(_ error: Error){
        let alert = UIAlertController(title: "Сохранение", message: "", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
        let actionReload = UIAlertAction(title: "Повторить", style: .default){
            [weak self](alert) in
            if let this = self {
                this.save(type: (this.lastTypeOfSaving))
            }
        }
        
        alert.addAction(actionOk)
        alert.addAction(actionReload)
        
        self.savingActivityIndicatorView.stopAnimating()
        self.present(alert, animated: true, completion: nil)
    }
    
    func readingFinishedwithError(_ error: Error){
        
    }
}

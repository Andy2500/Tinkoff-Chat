//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Andrey Nagaev on 07.03.17.
//  Copyright © 2017 Andrey Nagaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, StorageServiceDelegate, PhotoDelegate{
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var savingActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var saveButton: UIButton!

    var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTappend)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonPressed))
        
        self.savingActivityIndicatorView.hidesWhenStopped = true
//        self.savingActivityIndicatorView.startAnimating()
        
//        storageService.delegate = self
//        storageService.readUser()
        
        self.view.isUserInteractionEnabled = true
        let gR = SelfGestureRecognizer(target:self, action: nil)
        self.view.addGestureRecognizer(gR)
    }
    
    func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.saveButton.isEnabled = true
    }
    
    func endEditing(){
        loginTextField.endEditing(true)
        aboutTextView.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.saveButton.isEnabled = true
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
        
        let loadAction = UIAlertAction(title: "Загрузить", style: .default){(alert) in
            DispatchQueue.main.async {[weak self] in
                self?.performSegue(withIdentifier: "loadPhotos", sender: nil)
            }
        }
        
        choosingController.addAction(photoAction)
        choosingController.addAction(libraryAction)
        choosingController.addAction(loadAction)
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
        self.saveButton.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        savingActivityIndicatorView.startAnimating()
        
        let dictionary: [String : Any?] = ["name":loginTextField.text!, "about": aboutTextView.text, "image": UIImagePNGRepresentation(userImageView.image!)!]
        
        storageService.saveUser(dictionary)
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
            self.saveButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func userSaved(){
        DispatchQueue.main.async {[weak self] in
            let alert = UIAlertController(title: "Сохранение", message: "", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(actionOk)
            
            self?.saveButton.isEnabled = false
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func userLoaded(user: User?){
        DispatchQueue.main.async {[weak self] in
            if let user = user{
                self?.aboutTextView.text = user.about
                self?.loginTextField.text = user.name
                if user.image != nil {
                    self?.userImageView.image = UIImage(data: user.image as! Data)
                }
            }
            self?.savingActivityIndicatorView.stopAnimating()
        }
    }
    
    func photoSelected(photo: UIImage){
        self.userImageView.image = photo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVc = segue.destination as? UINavigationController{
            if let vc = navVc.viewControllers.first as? PhotosCollectionViewController{
                vc.delegate = self
            }
        }
    }
}


//
//  PhotosCollectionViewController.swift
//  Tinkoff Chat
//
//  Created by Андрей on 23.05.17.
//  Copyright © 2017 Andrey. All rights reserved.
//

import UIKit

protocol PhotoDelegate {
    func photoSelected(photo: UIImage)
}

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var photos:[PhotoApiModel] = []
    var service = PhotosService(requestSender: RequestSender())
    let pendingOperations = PendingOperations()
    var delegate: PhotoDelegate?
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 7.0, bottom: 8.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        self.collectionView?.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        service.loadPhotos(completionHandler:  self.updateCompleted)
        
        self.view.isUserInteractionEnabled = true
        let gR = SelfGestureRecognizer(target:self, action: nil)
        self.view.addGestureRecognizer(gR)
    }
    
    func updateCompleted(photos: [PhotoApiModel]?, string: String?) -> Void{
        if let photos = photos{
            self.photos = photos
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func close(){
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        
        let View=UIView()
        View.backgroundColor=UIColor(patternImage:photos[indexPath.row].image)
        cell.backgroundView=View
        
       
        self.startOperationsForPhotoRecord(photoDetails: photos[indexPath.row], indexPath: indexPath)
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoApiModel, indexPath: IndexPath){
        if photoDetails.state == .New{
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoApiModel, indexPath: IndexPath){
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(photoRecord: photoDetails)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            self.photos[indexPath.row] = downloader.photoRecord
            
            DispatchQueue.main.async{
                
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView?.reloadItems(at: [indexPath])
            }
        }

        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(photos[indexPath.row].state != .New && photos[indexPath.row].state != .Failed){
            self.delegate?.photoSelected(photo: photos[indexPath.row].image)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

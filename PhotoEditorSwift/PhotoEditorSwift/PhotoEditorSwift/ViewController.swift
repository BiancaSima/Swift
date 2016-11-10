//
//  ViewController.swift
//  PhotoEditorSwift
//
//  Created by Bianca Sima on 11/2/16.
//  Copyright © 2016 Bianca Sima. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    let imageView = UIImageView()
    var collectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let picker : UIImagePickerController! = UIImagePickerController()
    var imageCollection: UIImage!
    var assetCollection: PHAssetCollection!
    var albumFound : Bool = false
    var photosAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize?
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    var imageViewCollection: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.selectPhoto(_:)))
        navigationItem.rightBarButtonItem = doneButton
        
        createCollectionView(itemWidth: 40, itemHeight: 40)
 
        self.view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Create the collection view programmatically
    
    func createCollectionView(itemWidth: Double, itemHeight: Double){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    //MARK: - Add new photo to collection view
    
     func selectPhoto(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
            self.cameraGo(.camera)
        })
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
            self.cameraGo(.photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerViewSourceType
    
    func cameraGo(_ sourceType : UIImagePickerControllerSourceType) -> Void {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }   else {
            let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Please try again!", style: .default, handler: {
                action in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: UIImagePickerViewDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let theImage:UIImage!
        if picker.allowsEditing {
            theImage = info[UIImagePickerControllerEditedImage] as! UIImage
        }   else {
            theImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        picker.dismiss(animated: false, completion: nil)
        
        if let drawView = DrawCoreViewController(image: theImage, clourse: loadImage) {
            self.present(drawView, animated: true, completion: nil)
        }
    }
    
    //MARK: Closure
    
    func loadImage(_ image: UIImage) -> Void {
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width > view.frame.size.width ? view.frame.size.width:image.size.width, height: (image.size.width > view.frame.size.width ? view.frame.size.width:image.size.width) * image.size.height / image.size.width);
        imageView.image = image;
        imageView.center = view.center;
    }
    
    //MARK: - collection view functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor.orange
        let viewForImage = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        viewForImage.backgroundColor = UIColor.red
        imageViewCollection = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.width))
        viewForImage.addSubview(imageView)
        cell.addSubview(viewForImage)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    

}


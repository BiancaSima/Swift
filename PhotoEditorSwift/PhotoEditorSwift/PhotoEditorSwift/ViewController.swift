//
//  ViewController.swift
//  PhotoEditorSwift
//
//  Created by 0xfeedface on 16/7/15.
//  Copyright © 2016年 0xfeedface. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
            self.cameraGo(.camera)
        })
        let libraryAction = UIAlertAction(title: "", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
            self.cameraGo(.photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: "", style: .cancel, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraGo(_ sourceType : UIImagePickerControllerSourceType) -> Void {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }   else {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "", style: .default, handler: {
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
}


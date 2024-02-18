//
//  AddImageVC.swift
//  HappyBirthday
//
//  Created by Gili Yaakov on 16/02/2024.
//

import Foundation
import UIKit

protocol addImageDelegate {
    func imageDidChoose(pickedImage: UIImage)
}

class AddImageVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var onScreenVC: UIViewController?
    var delegate: addImageDelegate?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.imageDidChoose(pickedImage: pickedImage)
        }
        onScreenVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onScreenVC?.dismiss(animated: true, completion: nil)
    }
    
    func addPictureDidTapped() {
        // Check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Present an action sheet with options to choose from
            let actionSheet = UIAlertController(title: "Select Picture", message: nil, preferredStyle: .actionSheet)
            // Add action to open camera
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
                self.imagePicker.sourceType = .camera
                self.onScreenVC?.present(self.imagePicker, animated: true, completion: nil)
            }))
            // Add action to open photo library
            actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (_) in
                self.imagePicker.sourceType = .photoLibrary
                self.onScreenVC?.present(self.imagePicker, animated: true, completion: nil)
            }))
            // Add cancel action
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // Present the action sheet
            onScreenVC?.present(actionSheet, animated: true, completion: nil)
        } else {
            // If camera is not available, open the photo library directly
            self.imagePicker.sourceType = .photoLibrary
            self.onScreenVC?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

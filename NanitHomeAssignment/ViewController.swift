//
//  ViewController.swift
//  HappyBirthday
//
//  Created by Gili Yaakov on 14/02/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    
    let addImageController = AddImageVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        addImageController.imagePicker.delegate = addImageController
        addImageController.onScreenVC = self
        addImageController.delegate = self
        
        self.finishButton.isEnabled = false
        self.finishButton.tintColor = UIColor.gray
        birthDatePicker.maximumDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Happy Birthday"
        nameLabel.text = "Name:"
        birthDateLabel.text = "Birthday:"
        addPictureButton.setTitle("Add Picture", for: .normal)
        finishButton.setTitle("Show birthday screen", for: .normal)
    }
    
    @IBAction func addPitureDidTapped(_ sender: Any) {
        addImageController.addPictureDidTapped()
    }
    
    @IBAction func finishButtonDidTapped(_ sender: Any) {
    }
}

// TextField delegate handaling
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Combine the existing text with the replacement text
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        // Check if the new text is empty
        let isEmpty = newText.isEmpty
        if isEmpty {
            // When empty disable the finish button
            self.finishButton.isEnabled = false
            self.finishButton.tintColor = UIColor.gray
        } else {
            self.finishButton.isEnabled = true
            self.finishButton.tintColor = UIColor.black
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Image handaling
extension ViewController: addImageDelegate {
    func imageDidChoose(pickedImage: UIImage) {
        self.imageView.image = pickedImage
    }
}

//
//  ViewController.swift
//  NanitHomeAssignment
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
        
        // Set the title of the back button to an empty string to remove the default "Back" text (for next screen)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        birthDatePicker.maximumDate = Date()
        retrieveBabyInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Happy Birthday"
        nameLabel.text = "Name:"
        birthDateLabel.text = "Birthday:"
        addPictureButton.setTitle("Add Picture", for: .normal)
        finishButton.setTitle("Show birthday screen", for: .normal)
        imageView.image = SharedData.sharedData.babyInfo?.picture
    }
    
    @IBAction func addPitureDidTapped(_ sender: Any) {
        addImageController.addPictureDidTapped()
    }
    
    @IBAction func finishButtonDidTapped(_ sender: Any) {
        if let name = nameTextField.text {
            SharedData.sharedData.babyInfo = Baby(name: name, birthDate:  birthDatePicker.date, picture: self.imageView.image)
            saveBabyInfo() // For next Launch
            // Go to the next screen
            performSegue(withIdentifier: "detailsToBirthday", sender: self)
        }
    }
    
    func saveBabyInfo() {
        UserDefaults.standard.set(SharedData.sharedData.babyInfo?.name, forKey: "name")
        if let birthDate = SharedData.sharedData.babyInfo?.birthDate.toString() {
            UserDefaults.standard.set(birthDate, forKey: "date")
        }
        if (SharedData.sharedData.babyInfo?.picture) != nil {
            saveImage()
        }
    }
    
    func retrieveBabyInfo() {
        if let babyName = UserDefaults.standard.string(forKey: "name"),
           let birthDate = UserDefaults.standard.string(forKey: "date") {
            nameTextField.text = babyName
            birthDatePicker.date = birthDate.toDate() ?? Date()
            finishButton.tintColor = UIColor.black
            finishButton.isEnabled = true
        } else {
            finishButton.tintColor = UIColor.gray
            finishButton.isEnabled = false
        }
        if let retrivedImage = loadImage() {
            DispatchQueue.main.async {
                self.imageView.image = retrivedImage
            }
        }
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
extension ViewController: AddImageDelegate {
    func imageDidChoose(pickedImage: UIImage) {
        self.imageView.image = pickedImage
    }
    
    func saveImage() {
        guard let image = SharedData.sharedData.babyInfo?.picture,
              let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("babyImage.jpg")
        do {
            try data.write(to: fileURL)
            print("Image saved successfully at \(fileURL)")
        } catch {
            print("Error saving image: \(error)")
        }
    }

    func loadImage() -> UIImage? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("babyImage.jpg")
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}

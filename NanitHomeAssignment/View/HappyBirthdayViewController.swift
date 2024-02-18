//
//  HappyBirthdayViewController.swift
//  NaniHomeAssignment
//
//  Created by Gili Yaakov on 15/02/2024.
//

import Foundation
import UIKit

// Screen view options
enum ScreenView: Int {
    case elephant = 0
    case fox = 1
    case pelican = 2
}

class HappyBirthdayViewController: UIViewController, AddImageDelegate {
    @IBOutlet var backgroungView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageImage: UIImageView!
    @IBOutlet weak var numberTypeLabel: UILabel!
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    let addImageIcon = UIButton(type: .custom)
    let addImageController = AddImageVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        // Make sure the baby's picture is round
        babyImage.layer.cornerRadius = babyImage.frame.width / 2
        babyImage.clipsToBounds = true
        addImageIcon.addTarget(self, action: #selector(addImageDidTapped(_:)), for: .touchUpInside)
        addImageController.imagePicker.delegate = addImageController
        addImageController.onScreenVC = self
        addImageController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRandomView()
        if let name = SharedData.sharedData.babyInfo?.name.uppercased() {
            self.titleLabel.text = "TODAY \(name) IS"
        }
        setNumbersOnView()
        if let babyPicture = SharedData.sharedData.babyInfo?.picture {
            self.babyImage.image = babyPicture
        } // For no picture the place holder is alredy set
        createAddImageIcon()
    }
    
    func customizeBackButton() {
        // Create a custom back button image
        let backButtonImage = UIImage(named: "blueBackArrow")
        
        // Set the back indicator image for the navigation bar
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    func setRandomView() {
        // Choose a screen view randomly
        guard let screen = ScreenView(rawValue: Int.random(in: 0...2)) else { return }
        switch screen {
        case .elephant:
            self.background.image = UIImage(named: "Ebackground")
            backgroungView.backgroundColor = UIColor(hex: "#FEEFCB")
            babyImage.image = UIImage(named: "EpicturePlaceHolder")
            addImageIcon.setImage(UIImage(named: "EaddPicture"), for: .normal)
        case .fox:
            self.background.image = UIImage(named: "Fbackground")
            backgroungView.backgroundColor = UIColor(hex: "#C5E8DF")
            babyImage.image = UIImage(named: "FpicturePlaceHolder")
            addImageIcon.setImage(UIImage(named: "EaddPicture"), for: .normal)
        case .pelican:
            self.background.image = UIImage(named: "Pbackground")
            backgroungView.backgroundColor = UIColor(hex: "#DAF1F6")
            babyImage.image = UIImage(named: "PpicturePlaceHolder")
            addImageIcon.setImage(UIImage(named: "EaddPicture"), for: .normal)
        }
    }
    
    func setNumbersOnView() {
        if let ageInYears = SharedData.sharedData.babyInfo?.ageInYears,
           let ageInMonths = SharedData.sharedData.babyInfo?.ageInMonths {
            if ageInYears == 0 {
                self.ageImage.image = UIImage(named: String(ageInMonths))
                self.numberTypeLabel.text = "MONTHS OLD!"
            } else {
                self.ageImage.image = UIImage(named: String(ageInYears))
                self.numberTypeLabel.text = "YEARS OLD!"
            }
        }
    }
    
    @IBAction func addImageDidTapped(_ sender: Any) {
        addImageController.addPictureDidTapped()
    }
    
    func createAddImageIcon() {
        // Calculate the new center point for the target view
        let babyImageCenter = babyImage.center
        let babyImageHeight = babyImage.bounds.height
        // The Diagonal lenghth from the center to the wanted icon location
        let diagonalLength = ((pow(babyImageHeight/2, 2) * 2).squareRoot())/2
        let offset = (pow(diagonalLength, 2) / 2).squareRoot()
        let newCenter = CGPoint(x: babyImageCenter.x + offset, y: babyImageCenter.y - offset)
        addImageIcon.frame = CGRect(x: newCenter.x + 18, y: newCenter.y + 18, width: 36, height: 36)
        view.addSubview(addImageIcon)
    }
    
    func imageDidChoose(pickedImage: UIImage) {
        self.babyImage.image = pickedImage
        SharedData.sharedData.babyInfo?.picture = pickedImage
        saveImage()
    }
    @IBAction func shareButtonDidTapped(_ sender: Any) {
        if let screenCapture = captureScreen() {
            shareImage(image: screenCapture)
        }
    }
}

extension HappyBirthdayViewController {
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
    
    func captureScreen() -> UIImage? {
        // Hide all the elements that should not be included
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        addImageIcon.isHidden = true
        shareButton.isHidden = true
        
        // Get the main screen bounds
        let mainScreenBounds = UIScreen.main.bounds
        
        // Create a renderer with the main screen bounds
        let renderer = UIGraphicsImageRenderer(bounds: mainScreenBounds)
        
        // Render the main screen contents to an image
        let image = renderer.image { context in
            UIApplication.shared.keyWindow?.layer.render(in: context.cgContext)
        }
        
        // return all the hidden elements
        navigationController?.navigationBar.topItem?.setHidesBackButton(false, animated: false)
        addImageIcon.isHidden = false
        shareButton.isHidden = false
        
        return image
    }
    
    func shareImage(image: UIImage) {
        // Create a UIActivityViewController with the image to share
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // Present the UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
}

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

class HappyBirthdayViewController: UIViewController {
    @IBOutlet var backgroungView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageImage: UIImageView!
    @IBOutlet weak var numberTypeLabel: UILabel!
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        // Make sure the baby's picture is round
        babyImage.layer.cornerRadius = babyImage.frame.width / 2
        babyImage.clipsToBounds = true
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
        case .fox:
            self.background.image = UIImage(named: "Fbackground")
            backgroungView.backgroundColor = UIColor(hex: "#C5E8DF")
            babyImage.image = UIImage(named: "FpicturePlaceHolder")
        case .pelican:
            self.background.image = UIImage(named: "Pbackground")
            backgroungView.backgroundColor = UIColor(hex: "#DAF1F6")
            babyImage.image = UIImage(named: "PpicturePlaceHolder")
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
}

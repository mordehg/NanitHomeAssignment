//
//  Baby.swift
//  NanitHomeAssignment
//
//  Created by Gili Yaakov on 15/02/2024.
//

import Foundation
import UIKit

struct Baby {
    var name: String
    var birthDate: Date
    var ageInYears: Int = 0
    var ageInMonths: Int = 0
    var picture: UIImage?
    
    init(name: String, birthDate: Date, picture: UIImage? = nil) {
        self.name = name
        self.birthDate = birthDate
        self.picture = picture
        self.getDateDiffrence()
    }
    
    mutating func getDateDiffrence() {
        let calendar = Calendar.current
        // Calculate the difference between the two dates
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        // Access the difference in years and months
        if let years = components.year,
           let months = components.month {
            self.ageInYears = years
            self.ageInMonths = months
        }
    }
}

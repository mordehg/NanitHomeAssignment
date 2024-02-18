//
//  StringAndDate.swift
//  NanitHomeAssignment
//
//  Created by Gili Yaakov on 16/02/2024.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
       return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        return dateFormatter.string(from: self)
    }
}

//
//  SharedData.swift
//  NanitHomeAssignment
//
//  Created by Gili Yaakov on 17/02/2024.
//

import Foundation

class SharedData {
    
    var babyInfo: Baby?
    static let sharedData = SharedData()
    
    private init() {}
}

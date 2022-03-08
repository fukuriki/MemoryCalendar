//
//  Date-Extension.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2022/02/25.
//

import Foundation

extension Date {
    
    var year: Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        return components.year!
    }
    
    var month: Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month], from: self)
        return components.month!
    }
    
    var day: Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.day], from: self)
        return components.day!
    }
}

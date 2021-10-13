//
//  SettingDate.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/10/10.
//

import Foundation
import UIKit
import FSCalendar

class SettingDate {

//    let dateFormatter = DateFormatter()

    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .japanese)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .japanese)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

//        var dateFormatter: DateFormatter = {
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
//            return formatter
//        }()


}

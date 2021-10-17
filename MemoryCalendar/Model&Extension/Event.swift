//
//  Event.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/26.
//

import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var event: String = ""
    @objc dynamic var day: String = ""
    @objc dynamic var reviewDay1: String = ""
    @objc dynamic var reviewDay3: String = ""
    @objc dynamic var reviewDay7: String = ""
    @objc dynamic var reviewDay30: String = ""
//    @objc dynamic var memo: String = ""

//    override static func primaryKey() -> String? {
//        return "event"
//    }
//
//    override class func indexedProperties() -> [String] {
////        return ["day"], ["reviewDay1"], ["reviewDay3"], ["reviewDay7"], ["reviewDay30"]
//        return ["day, reviewDay1, reviewDay3, reviewDay7, reviewDay30"]
//    }
}

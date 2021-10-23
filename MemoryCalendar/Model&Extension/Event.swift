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
//    dynamic var order: Int? = 0
//    @objc dynamic var order: String? = ""
//    let order: Int?
//    @objc dynamic var memo: String = ""
    
//        let list = List<Event>()
//    let dataWrapper = List<DataWrapper>()

}

//class DataWrapper: Object {
//    let list = List<Event>()
////    @objc dynamic var order = 0
//}

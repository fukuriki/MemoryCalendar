//
//  DateRoom.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/10/27.
//

import Foundation
import RealmSwift

class DateRoom: Object {
    
    @objc dynamic var event: String = ""
    @objc dynamic var dateRoomId: String = ""
    @objc dynamic var order: Int = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}

//
//  Event.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/26.
//

import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
    @objc dynamic var memo: String = ""

}

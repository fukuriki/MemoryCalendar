//
//  TaskTableViewCell.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/29.
//

import Foundation
import UIKit
import RealmSwift

class TaskTableViewCell: UITableViewCell {
        
    var event: Event? {
        didSet {
            
        }
    }
    
    var dateRoom: DateRoom? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var eventTextView: UITextView!
//    @IBOutlet weak var reviewDayLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

}


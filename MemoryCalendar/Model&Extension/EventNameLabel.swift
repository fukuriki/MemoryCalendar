//
// EventNameLabel.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2022/05/13.
//

import Foundation
import UIKit
import FSCalendar

class EventNameLabel: UILabel {
        
    init(cell: FSCalendarCell, eventLabelText: String?) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: 12)
        textColor = UIColor.systemGreen
        layer.cornerRadius = cell.bounds.width/2
        
        if let firstEventString = eventLabelText {
            text = firstEventString
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

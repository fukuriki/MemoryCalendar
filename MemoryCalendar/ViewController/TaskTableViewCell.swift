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
//        adjustingEventText()
        
    }
    
    private func adjustingEventText() {
        
//        do {
//            let realm = try! Realm()
//            let eventList = realm.objects(Event.self)
//
//        } catch {
//
//            if let event = event {
//                print("event.event: ", event.event)
//            eventTextView.text = event.event
//           //            let width = estimateFrameForTextView(text: event.event).width + 20
//           //            eventTextView
//        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        return
//    }
    
//    private func estimateFrameForTextView(text: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
//    }
    
}


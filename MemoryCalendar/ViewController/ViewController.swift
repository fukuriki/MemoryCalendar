//
//  ViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/23.
//

import UIKit
import FSCalendar
import RealmSwift
import SnapKit

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var eventList: Results<Event>!
    var reviewDay1Key: String?
    var reviewDay3Key: String?
    var reviewDay7Key: String?
    var reviewDay30Key: String?
    var eventString = ""

    @IBOutlet weak var Calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        eventList = self.realm.objects(Event.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("viewWillAppear")
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let setMemoryViewController = storyboard.instantiateViewController(withIdentifier: "Insert") as? SetMemoryViewController
        let nav = UINavigationController(rootViewController: setMemoryViewController!)        
        
        if let setMemoryViewController = setMemoryViewController {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd"
            let string = dateFormatter.string(from: date)
            setMemoryViewController.date = SettingDate.dateFromString(string: string, format: "y-MM-dd")
            
            present(nav, animated: true, completion: nil)
        }
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    
//        let x = realm.objects(Event.self).first
//        let date = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        var hasEvent: Bool = false
//
//        for eventModel in Event
//    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let filteredEventString = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").first?.list.first?.event
        
        if filteredEventString == nil {
            let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'").first?.event
            return filteredEventStringInDateRoom
        } else {
            return filteredEventString
        }
    }
}

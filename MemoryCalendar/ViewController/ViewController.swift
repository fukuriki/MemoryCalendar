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
//import SwiftUI

class ViewController: UIViewController
//, UIViewRepresentable
{
    
    var eventList: Results<Event>!
    var reviewDay1Key: String?
    var reviewDay3Key: String?
    var reviewDay7Key: String?
    var reviewDay30Key: String?
    var eventString = ""
    var eachSecondEvent = ""
    var eachThirdEvent = ""

    @IBOutlet weak var Calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        
        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            
    //        print(Realm.Configuration.defaultConfiguration.fileURL!)
    //        try! realm.write({
    //            realm.deleteAll()
    //        })
        } catch {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
        self.Calendar.reloadData()
//        updateUIView(<#T##uiView: UIViewRepresentable.UIViewType##UIViewRepresentable.UIViewType#>, context: <#T##UIViewRepresentableContext<UIViewRepresentable>#>)
    }
    
//    func updateUIView(_ uiView: FSCalendar, context: Context) {
//
//    }
    
}

//protocol Update {
//    func updateUIView(_ uiView: FSCalendar) {
//        uiView.reloadData()
//    }
//}

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

//        print("subtitleFor")
        do {
            
            let realm = try Realm()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd"
            let dateString = dateFormatter.string(from: date)
            let filteredEventString = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").first?.list.first?.event
            
//            dateRoomListの２番目と３番目のevent取得しようとしてるやつ
//            let filteredListInDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//
//            for indexA in filteredListInDateRoomList.indices {
//                self.eachSecondEvent = filteredListInDateRoomList.last?.list[indexA + 1].event ?? ""
//                self.eachThirdEvent = filteredListInDateRoomList.last?.list[indexA + 2].event ?? ""
////                print("eachEvent: ", eachEvent ?? "")
//
//            }
//
//            let returnedString = "\(filteredEventString)\n\(self.eachSecondEvent)\n\(self.eachThirdEvent)"
//            print("returnedString: ", returnedString)
//            return returnedString


            
//            let filteredEventStringArray = Array(filteredEventString)
            
            if filteredEventString == nil {
                let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'").first?.event
                return filteredEventStringInDateRoom
            } else {
                return filteredEventString
            }
        } catch {
            return nil
        }
    }
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("calendarCurrentPageDidChange")
//    }
    
//    calendar
}

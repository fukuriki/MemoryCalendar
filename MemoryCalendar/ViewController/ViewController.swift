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
//    var date = Date()
    var eventString = ""
    var eachSecondEvent: String? = ""
    var eachThirdEvent: String? = ""

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
        
//        print("viewWillAppear")
        self.Calendar.reloadData()
//        updateUIView(<#T##uiView: UIViewRepresentable.UIViewType##UIViewRepresentable.UIViewType#>, context: <#T##UIViewRepresentableContext<UIViewRepresentable>#>)
    }
    
    
    
    func makeStackViewOfOneElement(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        
        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        print("dateRoom: ", dateRoom)
        
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
        
        let eventLabel = UILabel()
     //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
                 eventLabel.font = UIFont.systemFont(ofSize: 12)

                 if let firstEventString = filteredDateRoomList.first?.list.first?.event {
                     print("firstEventString")
                 eventLabel.text = firstEventString
                 }
                 eventLabel.textColor = UIColor.systemMint
                 eventLabel.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel2 = UILabel()
     //            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel2.font = UIFont.systemFont(ofSize: 12)
//        if self.eachSecondEvent == filteredDateRoomList.last?.list[1].event {
//            eventLabel2.text = self.eachSecondEvent
//                 }
                 eventLabel2.textColor = UIColor.systemMint
                 eventLabel2.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel3 = UILabel()
     //            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel3.font = UIFont.systemFont(ofSize: 12)
//        if self.eachThirdEvent == filteredDateRoomList.last?.list[2].event {
//            eventLabel3.text = self.eachThirdEvent
//                 }
                 eventLabel3.textColor = UIColor.systemMint
                 eventLabel3.layer.cornerRadius = cell.bounds.width/2

                 let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
                 stackView.axis = .vertical
                 stackView.distribution = .fillEqually
                 stackView.translatesAutoresizingMaskIntoConstraints = false

                 cell.addSubview(stackView)

                 stackView.alignment = .center
                 stackView.snp.makeConstraints { make in

                     make.width.equalTo(75)
                     make.height.equalTo(45)
                     make.centerX.equalTo(cell.snp_centerXWithinMargins)
                     make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
                 }
    }
    
    func makeStackViewOfTwoElement(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        
        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        print("dateRoom: ", dateRoom)
        
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
        
        let eventLabel = UILabel()
     //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
                 eventLabel.font = UIFont.systemFont(ofSize: 12)

                 if let firstEventString = filteredDateRoomList.first?.list.first?.event {
                     print("firstEventString")
                 eventLabel.text = firstEventString
                 }
                 eventLabel.textColor = UIColor.systemMint
                 eventLabel.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel2 = UILabel()
     //            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel2.font = UIFont.systemFont(ofSize: 12)
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
                 }
//        if self.eachSecondEvent == filteredDateRoomList.last?.list[1].event {
//            eventLabel2.text = self.eachSecondEvent
//                 }
                 eventLabel2.textColor = UIColor.systemMint
                 eventLabel2.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel3 = UILabel()
     //            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel3.font = UIFont.systemFont(ofSize: 12)
                 eventLabel3.textColor = UIColor.systemMint
                 eventLabel3.layer.cornerRadius = cell.bounds.width/2

                 let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
                 stackView.axis = .vertical
                 stackView.distribution = .fillEqually
                 stackView.translatesAutoresizingMaskIntoConstraints = false

                 cell.addSubview(stackView)

                 stackView.alignment = .center
                 stackView.snp.makeConstraints { make in

                     make.width.equalTo(75)
                     make.height.equalTo(45)
                     make.centerX.equalTo(cell.snp_centerXWithinMargins)
                     make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
                 }
    }
    
    func makeStackViewOfThreeElement(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        
        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        print("dateRoom: ", dateRoom)
        
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
        
        let eventLabel = UILabel()
     //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
                 eventLabel.font = UIFont.systemFont(ofSize: 12)

                 if let firstEventString = filteredDateRoomList.first?.list.first?.event {
                     print("firstEventString")
                 eventLabel.text = firstEventString
                 }
                 eventLabel.textColor = UIColor.systemMint
                 eventLabel.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel2 = UILabel()
     //            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel2.font = UIFont.systemFont(ofSize: 12)
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
                 }
                 eventLabel2.textColor = UIColor.systemMint
                 eventLabel2.layer.cornerRadius = cell.bounds.width/2

                 let eventLabel3 = UILabel()
     //            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
                 eventLabel3.font = UIFont.systemFont(ofSize: 12)
        if let thirdEventString = filteredDateRoomList.last?.list[2].event {
            eventLabel3.text = thirdEventString
                 }
                 eventLabel3.textColor = UIColor.systemMint
                 eventLabel3.layer.cornerRadius = cell.bounds.width/2

                 let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
                 stackView.axis = .vertical
                 stackView.distribution = .fillEqually
                 stackView.translatesAutoresizingMaskIntoConstraints = false

                 cell.addSubview(stackView)

                 stackView.alignment = .center
                 stackView.snp.makeConstraints { make in

                     make.width.equalTo(75)
                     make.height.equalTo(45)
                     make.centerX.equalTo(cell.snp_centerXWithinMargins)
                     make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
                 }
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
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {

             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "y-MM-dd"
             let dateString = dateFormatter.string(from: date)
     //        print("dateString: ", dateString)
             
             let realm = try! Realm()
        
//        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//
//        for index in filteredDateRoom.indices {
//
////            let eventIndex = index.successor()
//
//            let eventLabel = UILabel()
////                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング
//            eventLabel.font = UIFont.systemFont(ofSize: 12)
//
//            if let firstEventString = filteredDateRoom.first?.event {
//                print("firstEventString")
//            eventLabel.text = firstEventString
//            }
//            eventLabel.textColor = UIColor.systemMint
//            eventLabel.layer.cornerRadius = cell.bounds.width/2
//
//            let eventLabel2 = UILabel()
////            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
//            eventLabel2.font = UIFont.systemFont(ofSize: 12)
//
////            eventLabel2.text = filteredDateRoom[]
////            eventLabel2.text = filteredDateRoom[index + 1].event
//            if self.eachSecondEvent == filteredDateRoom[index].event {
//                eventLabel2.text = self.eachSecondEvent
//            }
////            if let secondEventString = filteredDateRoom[index + 1].event {
////                eventLabel2.text = secondEventString
////            }
//
//            eventLabel2.textColor = UIColor.systemMint
//            eventLabel2.layer.cornerRadius = cell.bounds.width/2
//
//            let eventLabel3 = UILabel()
////            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
//            eventLabel3.font = UIFont.systemFont(ofSize: 12)
//
////            eventLabel3.text = filteredDateRoom[index + 2].event
//            if self.eachThirdEvent == filteredDateRoom[index].event {
//                eventLabel3.text = self.eachThirdEvent
//            }
////            if let thirdEventString = filteredDateRoom[index + 2].event {
////                eventLabel3.text = thirdEventString
////            }
//
//            eventLabel3.textColor = UIColor.systemMint
//            eventLabel3.layer.cornerRadius = cell.bounds.width/2
//
//            let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
//            stackView.axis = .vertical
//            stackView.distribution = .fillEqually
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//
//            cell.addSubview(stackView)
//
//            stackView.alignment = .center
//            stackView.snp.makeConstraints { make in
//
//                make.width.equalTo(75)
//                make.height.equalTo(45)
//                make.centerX.equalTo(cell.snp_centerXWithinMargins)
//                make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
//            }
//        }
        
//        -------------------dateRoomList
             let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//             print("filteredDateRoomList: ", filteredDateRoomList)
        let eventCount = filteredDateRoomList.last?.list.count
        print("eventCount: ", eventCount ?? 0)
        
        switch eventCount {
        case nil:
            print("0")
        case 1:
            print("1")
            makeStackViewOfOneElement(cell: cell, cellDate: date)
        case 2:
            print("2")
            makeStackViewOfTwoElement(cell: cell, cellDate: date)
        default:
            print("３以上")
            makeStackViewOfThreeElement(cell: cell, cellDate: date)
        }

//             for index in filteredDateRoomList.indices {

//                 cell.delete(monthPosition)
//                 cell.removeFromSuperview()
//                 cell.calendar


//                 let firstEventString = filteredDateRoomList.first?.list.first?.event
//        let secondEventString = filteredDateRoomList.last?.list[1].event
//                 let thirdEventString = filteredDateRoomList.last?.list[2]
//        print("secondEventString: ", secondEventString ?? [])
//        print("thirdEventString: ", thirdEventString ?? [])

//        -----------method化
//                 let eventLabel = UILabel()
//     //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング
//                 eventLabel.font = UIFont.systemFont(ofSize: 12)
//
//                 if let firstEventString = filteredDateRoomList.first?.list.first?.event {
//                     print("firstEventString")
//                 eventLabel.text = firstEventString
//                 }
//                 eventLabel.textColor = UIColor.systemMint
//                 eventLabel.layer.cornerRadius = cell.bounds.width/2
//
//                 let eventLabel2 = UILabel()
//     //            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
//                 eventLabel2.font = UIFont.systemFont(ofSize: 12)
////        if self.eachSecondEvent == filteredDateRoomList.last?.list[1].event {
////            eventLabel2.text = self.eachSecondEvent
////                 }
//                 eventLabel2.textColor = UIColor.systemMint
//                 eventLabel2.layer.cornerRadius = cell.bounds.width/2
//
//                 let eventLabel3 = UILabel()
//     //            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
//                 eventLabel3.font = UIFont.systemFont(ofSize: 12)
////        if self.eachThirdEvent == filteredDateRoomList.last?.list[2].event {
////            eventLabel3.text = self.eachThirdEvent
////                 }
//                 eventLabel3.textColor = UIColor.systemMint
//                 eventLabel3.layer.cornerRadius = cell.bounds.width/2
//
//                 let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
//                 stackView.axis = .vertical
//                 stackView.distribution = .fillEqually
//                 stackView.translatesAutoresizingMaskIntoConstraints = false
//
//                 cell.addSubview(stackView)
//
//                 stackView.alignment = .center
//                 stackView.snp.makeConstraints { make in
//
//                     make.width.equalTo(75)
//                     make.height.equalTo(45)
//                     make.centerX.equalTo(cell.snp_centerXWithinMargins)
//                     make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
//                 }
//        -----------method化

//                 if firstEventString == nil {
//                     print("firstEventStringがニル")
//                     let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'").first?.event
//                     eventLabel.text = filteredEventStringInDateRoom
//                 }

//                 cell.calendar.reloadData()
//             } // indices
//        ---------------dateRoomList
        
        
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        let x = realm.objects(Event.self).first
//        let date = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        var hasEvent: Bool = false
//
//        for eventModel in Event
//    }


//    ----------------
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//
////        print("subtitleFor")
//        do {
//
//            let realm = try Realm()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "y-MM-dd"
//            let dateString = dateFormatter.string(from: date)
//            let filteredEventString = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").first?.list.first?.event
//
////            dateRoomListの２番目と３番目のevent取得しようとしてるやつ
//            let filteredListInDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//            print("filteredListInDateRoomList: ", filteredListInDateRoomList)
//
////            for index in filteredListInDateRoomList.indices {
//
////            let event2 = filteredListInDateRoomList.last?.list[1].event
////            let event3 = filteredListInDateRoomList.last?.list[2].event
//            //            print("event2: ", event2 ?? "")
//            //            print("event3: ", event3 ?? "")
//
////                self.eachSecondEvent = filteredListInDateRoomList.last?.list[1].event
////                self.eachThirdEvent = filteredListInDateRoomList.last?.list[2].event
////                self.eachSecondEvent = filteredListInDateRoomList.last?.list[index + 1].event ?? ""
////                self.eachThirdEvent = filteredListInDateRoomList.last?.list[index + 2].event ?? ""
//
////            }
////
////            let returnedString = "\(filteredEventString)\n\(self.eachSecondEvent)\n\(self.eachThirdEvent)"
////            print("returnedString: ", returnedString)
////            return returnedString
//
//
//
////            let filteredEventStringArray = Array(filteredEventString)
//
//            if filteredEventString == nil  {
//                let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'").first?.event
//                return filteredEventStringInDateRoom
////            } else if event2 == nil {
////                let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'")[1].event
////                return filteredEventStringInDateRoom
////            } else if event3 == nil {
////                let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'")[2].event
////                return filteredEventStringInDateRoom
//            } else {
//                return nil
//            }
//            } catch {
//            return nil
//        }
//    }
//    ---------------
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("calendarCurrentPageDidChange")
//    }
    
//    calendar
}


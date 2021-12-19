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
//    var eventTextString : String? = ""
//    typealias ExecuteOnce = () -> ()

    // 一度だけ引数にしていされたクロージャを実行するクロージャを返す関数
//    func executeOnce(execute: () -> ()) -> ExecuteOnce {
//        var first = true
//        return {
//            if (first) {
//                first = false
//                execute()
//            }
//        }
//    }
    
    @IBOutlet weak var Calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
//        let realm = try! Realm()
        eventList = self.realm.objects(Event.self)

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
    
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("calendarCurrentPageDidChange")
//    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let filteredEventString = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").first?.list.first?.event
//        print("filteredEventString: ", filteredEventString ?? "")
//        self.eventString = filteredEventString
        
        if filteredEventString == nil {
            let filteredEventStringInDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'").first?.event
//            print("filteredEventStringInDateRoom: ", filteredEventStringInDateRoom ?? "")
//            print("filteredEventStringInDateRoom: ", filteredEventStringInDateRoom ?? "")
            return filteredEventStringInDateRoom
        } else {
            return filteredEventString
        }
        
//        return filteredEventString
        
//        Eventモデルで模索
//        let eventListArray = Array(eventList)
//        let filteredEventListArray = eventListArray.filter {
//            $0.day.contains("\(dateString)")
//            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//        }
//        print("filteredEventListArray: ", filteredEventListArray)
//
//        for index in filteredEventListArray.indices {
//            let filteredReviewDay1 = filteredEventListArray[index].reviewDay1
//            let filteredReviewDay3 = filteredEventListArray[index].reviewDay3
//            let filteredReviewDay7 = filteredEventListArray[index].reviewDay7
//            let filteredReviewDay30 = filteredEventListArray[index].reviewDay30
//
//            self.reviewDay1Key = filteredReviewDay1
//            self.reviewDay3Key = filteredReviewDay3
//            self.reviewDay7Key = filteredReviewDay7
//            self.reviewDay30Key = filteredReviewDay30
//            print("reviewDay1Key: ", reviewDay1Key ?? "")
//            print("reviewDay3Key: ", reviewDay3Key ?? "")
//            print("reviewDay7Key: ", reviewDay7Key ?? "")
//            print("reviewDay30Key: ", reviewDay30Key ?? "")
//
//        }
        
//        let filteredEventDate = realm.objects(Event.self).filter("dateRoomId contains '\(dateString)'")
        
        
        
        
//        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
        
//
//        for listIndex in filteredDateRoomList.indices {
//
//
//            let eventText = filteredDateRoomList[listIndex].list.first?.event
//            print("eventText: ", eventText ?? "")
//
////            if filteredDateRoomList.isEmpty == true {
//
//            eventTextString = eventText
////            print("eventTextString: ", eventTextString ?? "")
//
//
////            if eventTextString != ""
//////                && filteredDateRoomList.isEmpty == false
////            {
////                print("からじゃないでし")
////
//////                eventTextString = eventText
//////                eventTextString?.append(eventText ?? "")
////                print("eventTextString: ", eventTextString ?? "")
////
////            } else {
////                print("からでし")
////                eventTextString?.append(eventText ?? "")
////                print("eventTextStringAfterAppend: ", eventTextString ?? "")
////            }
//    }
//
////        let eventText = filteredDateRoomList.first.list
////
////        let eventText = filteredDateRoomList.indices {
////            let x: String? = filteredDateRoomList[listIndex].list.first?.event
////            print("eventText: ", eventText ?? "")
////        }
////        return eventText
////
//        return self.eventTextString
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "y-MM-dd"
//        let dateString = dateFormatter.string(from: date)
////        print("dateString: ", dateString)
//
//        let realm = try! Realm()
//        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
//
//
//        for listIndex in filteredDateRoomList.indices {
//
//            guard let eventText = filteredDateRoomList[listIndex].list.first?.event else { return }
//            print("eventText: ", eventText)
//
////            var someInitialize: ExecuteOnce = {
//
//            if cell.subviews.isEmpty == false {
//
//                print("からじゃないです")
//
//                let eventLabel = UILabel()
//                eventLabel.font = UIFont.systemFont(ofSize: 12)
//                eventLabel.text = eventText
//                eventLabel.textColor = UIColor.systemMint
//                eventLabel.layer.cornerRadius = cell.bounds.width/2
//
//                let eventLabel2 = UILabel()
//                eventLabel2.font = UIFont.systemFont(ofSize: 12)
//                eventLabel2.text = ""
//                eventLabel2.textColor = UIColor.systemMint
//                eventLabel2.layer.cornerRadius = cell.bounds.width/2
//
//                let eventLabel3 = UILabel()
//                eventLabel3.font = UIFont.systemFont(ofSize: 12)
//                eventLabel3.text = ""
//                eventLabel3.textColor = UIColor.systemMint
//                eventLabel3.layer.cornerRadius = cell.bounds.width/2
//
//                let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
//                stackView.axis = .vertical
//                stackView.distribution = .fillEqually
//                stackView.translatesAutoresizingMaskIntoConstraints = false
//
//                cell.addSubview(stackView)
//
//                stackView.alignment = .center
//                stackView.snp.makeConstraints { make in
//
//                    make.width.equalTo(75)
//                    make.height.equalTo(45)
//                    make.centerX.equalTo(cell.snp_centerXWithinMargins)
//                    make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
//                }
//            }
//            }
//
////        cell.delete(<#T##sender: Any?##Any?#>)
////        cell.removeFromSuperview() //全部消える
////        cell.removeFromSuperview(stackView)
//
//
////            required init(coder aDecoder: NSCoder) {
////                super.init(coder: aDecoder)
////
////                someInitialize = executeOnce {
////                    [unowned self] in
////                }
////            }
////        }
    }
}

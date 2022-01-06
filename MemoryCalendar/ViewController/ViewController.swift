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
    
//    var eventList: Results<Event>!
    var reviewDay1Key: String?
    var reviewDay3Key: String?
    var reviewDay7Key: String?
    var reviewDay30Key: String?
    var isFirst = Bool()

    @IBOutlet weak var Calendar: FSCalendar!
    @IBOutlet weak var cellReloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("(^q^)")
        
        Calendar.delegate = self
        Calendar.dataSource = self

        cellReloadButton.layer.cornerRadius = 10
        cellReloadButton.addTarget(self, action: #selector(tappedCellReloadButton), for: .touchUpInside)
        
//        do {
//            let realm = try Realm()
//            eventList = realm.objects(Event.self)
            
    //        print(Realm.Configuration.defaultConfiguration.fileURL!)
//            try! realm.write({
//                realm.deleteAll()
//            })
//        } catch {
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Calendar.delegate = self
//        Calendar.dataSource = self
//
//        cellReloadButton.layer.cornerRadius = 10
//        cellReloadButton.addTarget(self, action: #selector(tappedCellReloadButton), for: .touchUpInside)
        
//        print("viewWillAppear")
//        self.viewDidLoad()
//        updateUIView(<#T##uiView: UIViewRepresentable.UIViewType##UIViewRepresentable.UIViewType#>, context: <#T##UIViewRepresentableContext<UIViewRepresentable>#>)
    }
    
    @objc private func tappedCellReloadButton() {
        
        print("tappedCellReloadButton")
        
        self.Calendar.removeFromSuperview()
        
        self.loadView()
        self.viewDidLoad()
//        self.viewWillAppear(true)
        self.Calendar.reloadData()

//        print("count: ", view.subviews.count)
        
//        for subview in view.subviews {
////            if let subview = subview as? UIStackView, subview.tag == 1 {
//            print("subview: ", subview)
////                subview.removeFromSuperview()
////            }
//        }
        
//        for subview in cell.subviews {
//            if let subview = subview as? UIStackView, subview.tag == 1 {
//            print("subview: ", subview)
//                subview.removeFromSuperview()
//            }
//        }
        
//        for subview in view.subviews {
//            print("subview: ", subview)
//        }
        
//        updateUIView(Calendar)
        
//        -----------
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "y-MM-dd"
//        let dateString = dateFormatter.string(from: date)
//
//        let realm = try! Realm()
//        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        let eventCountInDateRoomList = filteredDateRoomList.last?.list.count
//        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//        let eventCountInDateRoom = filteredDateRoom.count
//        //        print("eventCountInDateRoom: ", eventCountInDateRoom)
//
//        switch eventCountInDateRoomList {
//        case nil: break
//        case 1:
//            makeStackViewOfOneElement(cell: cell, cellDate: date)
//        case 2:
//            makeStackViewOfTwoElement(cell: cell, cellDate: date)
//        default:
//            makeStackViewOfThreeElement(cell: cell, cellDate: date)
//        }
//
//        if eventCountInDateRoomList == nil {
//
//            switch eventCountInDateRoom {
//            case 0: break
//            case 1:
//                makeStackViewOfOneElementByDateRoom(cell: cell, cellDate: date)
//            case 2:
//                makeStackViewOfTwoElementByDateRoom(cell: cell, cellDate: date)
//            default:
//                makeStackViewOfThreeElementByDateRoom(cell: cell, cellDate: date)
//            }
//        }
        
//        willDisplayCopy(cell: <#T##FSCalendarCell#>, date: <#T##Date#>)
        
//        print("view.subviews: ", view.subviews)

//        self.Calendar.delete(self.Calendar.superview)
        
//        self.viewWillAppear(true)
//        self.viewDidLoad()
//        self.Calendar.delete()
//        self.Calendar.reloadData()
        
    }
    
//    func willDisplayCopy(completion: () -> Void) {
//
//    }
    
//    func willDisplayCopy(cell: FSCalendarCell, date: Date) {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "y-MM-dd"
//        let dateString = dateFormatter.string(from: date)
//
//        let realm = try! Realm()
//        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        let eventCountInDateRoomList = filteredDateRoomList.last?.list.count
//        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//        let eventCountInDateRoom = filteredDateRoom.count
////        print("eventCountInDateRoom: ", eventCountInDateRoom)
//
//        switch eventCountInDateRoomList {
//        case nil: break
//        case 1:
//            makeStackViewOfOneElement(cell: cell, cellDate: date)
//        case 2:
//            makeStackViewOfTwoElement(cell: cell, cellDate: date)
//        default:
//            makeStackViewOfThreeElement(cell: cell, cellDate: date)
//        }
//
//        if eventCountInDateRoomList == nil {
//
//            switch eventCountInDateRoom {
//            case 0: break
//            case 1:
//                makeStackViewOfOneElementByDateRoom(cell: cell, cellDate: date)
//            case 2:
//                makeStackViewOfTwoElementByDateRoom(cell: cell, cellDate: date)
//            default:
//                makeStackViewOfThreeElementByDateRoom(cell: cell, cellDate: date)
//            }
//        }
//    }
    
    private func deleteStackView(cell: FSCalendarCell) {
        for subview in cell.subviews {
            if let stackView = subview as? UIStackView {
//                print("stackView: ", stackView)
                stackView.removeFromSuperview()
            }
        }
    }
    
   private func makeStackViewOfOneElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        //        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
//        cell.viewWithTag(1)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfTwoElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        //        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
        }
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemMint
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfThreeElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        //        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
        }
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemMint
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        if let thirdEventString = filteredDateRoomList.last?.list[2].event {
            eventLabel3.text = thirdEventString
        }
        eventLabel3.font = UIFont.systemFont(ofSize: 12)
        eventLabel3.textColor = UIColor.systemMint
        eventLabel3.layer.cornerRadius = cell.bounds.width/2
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfOneElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        //        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfTwoElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
//                let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoom: ", filteredDateRoom)
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        eventLabel2.text = filteredDateRoom[1].event
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemMint
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfThreeElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        //        let dateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoom: ", filteredDateRoom)
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemMint
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        eventLabel2.text = filteredDateRoom[1].event
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemMint
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        eventLabel3.text = filteredDateRoom[2].event
        eventLabel3.font = UIFont.systemFont(ofSize: 12)
        eventLabel3.textColor = UIColor.systemMint
        eventLabel3.layer.cornerRadius = cell.bounds.width/2
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(stackView)
//        self.view.bringSubviewToFront(stackView)
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
//    func updateUIView(_ uiView: FSCalendar) {
////        if (canReload == false) { return }
//        uiView.reloadData()
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
        
//        print("willDisplay1")

//        if isFirst == true { return }
//        print("willDisplay2")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: date)
//        print("dateString: ", dateString)

        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList)
        let eventCountInDateRoomList = filteredDateRoomList.last?.list.count
//        print("eventCountInDateRoomList: ", eventCountInDateRoomList)
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoom: ", filteredDateRoom)
        let eventCountInDateRoom = filteredDateRoom.count
//        print("eventCountInDateRoom: ", eventCountInDateRoom)

        switch eventCountInDateRoomList {
        case nil:
            deleteStackView(cell: cell)
        case 1:
            deleteStackView(cell: cell)
            makeStackViewOfOneElementByDateRoomList(cell: cell, cellDate: date)
        case 2:
            deleteStackView(cell: cell)
            makeStackViewOfTwoElementByDateRoomList(cell: cell, cellDate: date)
        default:
            deleteStackView(cell: cell)
            makeStackViewOfThreeElementByDateRoomList(cell: cell, cellDate: date)
        }

        if eventCountInDateRoomList == nil {

            switch eventCountInDateRoom {
            case 0:
                deleteStackView(cell: cell)
            case 1:
                deleteStackView(cell: cell)
                makeStackViewOfOneElementByDateRoom(cell: cell, cellDate: date)
            case 2:
                deleteStackView(cell: cell)
                makeStackViewOfTwoElementByDateRoom(cell: cell, cellDate: date)
            default:
                deleteStackView(cell: cell)
                makeStackViewOfThreeElementByDateRoom(cell: cell, cellDate: date)
            }
        }
        
//        cellReloadButton.addTarget(self, action: #selector(tappedCellReloadButton(cell: cell, date: date)), for: .touchUpInside)

//        cellReloadButton.behavioralStyle = .automatic
        
        
//        if cellReloadButton.
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        let x = realm.objects(Event.self).first
//        let date = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        var hasEvent: Bool = false
//
//        for eventModel in Event
//    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("---------------------calendarCurrentPageDidChange")
        
//        let currentPage = self.Calendar.currentPage
//        print("currentPage: ", currentPage)
//
//        print("calendar: ", calendar.subviews)
        
        
//        self.Calendar.removeFromSuperview()
//
////        view.addSubview(Calendar)
//
////        self.loadViewIfNeeded()
////        self.Calendar.
//
//        self.loadView()
//        self.viewWillAppear(true)
////        self.viewDidLoad()
//
//        self.Calendar.reloadData()
    }
}

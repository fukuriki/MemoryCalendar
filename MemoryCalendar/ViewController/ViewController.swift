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
    
    @IBOutlet weak var Calendar: FSCalendar!
    @IBOutlet weak var cellReloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        cellReloadButton.layer.cornerRadius = 10
        cellReloadButton.addTarget(self, action: #selector(tappedCellReloadButton), for: .touchUpInside)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    @objc private func tappedCellReloadButton() {
        
        self.Calendar.removeFromSuperview()
        self.loadView()
        self.viewDidLoad()
        self.Calendar.reloadData()
    }
    
    private func deleteStackView(cell: FSCalendarCell) {
        for subview in cell.subviews {
            if let stackView = subview as? UIStackView {
                stackView.removeFromSuperview()
            }
        }
    }
    
    private func identifyTodayEventAndSetupNotification(date: Date, year: Int, month: Int, day: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let todayString = dateFormatter.string(from: date)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(todayString)'")
        let message = filteredDateRoom.first?.event
        
        switch filteredDateRoom.count {
        case 1:
            setupNotification(message: message ?? "", year: year, month: month, day: day)
        case 2:
            if let unwrappedMessage = message {
                setupNotification(message: "1.\(unwrappedMessage)\n2.\(filteredDateRoom[1].event)", year: year, month: month, day: day)
            }
        case 3:
            if let unwrappedMessage = message {
                setupNotification(message: "1.\(unwrappedMessage)\n2.\(filteredDateRoom[1].event)\n3.\(filteredDateRoom[2].event)", year: year, month: month, day: day)
            }
        default: break
        }
    }
    
    private func setupNotification(message: String, year: Int, month: Int, day: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "今日のタスク(優先順)"
        content.body = message
        content.sound = UNNotificationSound.default
        
        let date = DateComponents(year: year, month: month, day: day, hour: 8)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        let request = UNNotificationRequest.init(identifier: "\(year)-\(month)-\(day)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func makeStackViewOfOneElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用?
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
    }
    
    private func makeStackViewOfTwoElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
        }
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemGreen
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
    }
    
    private func makeStackViewOfThreeElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoomList.first?.list.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        if let secondEventString = filteredDateRoomList.last?.list[1].event {
            eventLabel2.text = secondEventString
        }
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemGreen
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        if let thirdEventString = filteredDateRoomList.last?.list[2].event {
            eventLabel3.text = thirdEventString
        }
        eventLabel3.font = UIFont.systemFont(ofSize: 12)
        eventLabel3.textColor = UIColor.systemGreen
        eventLabel3.layer.cornerRadius = cell.bounds.width/2
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
    }
    
    private func makeStackViewOfOneElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
    }
    
    private func makeStackViewOfTwoElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        eventLabel2.text = filteredDateRoom[1].event
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemGreen
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
    }
    
    private func makeStackViewOfThreeElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        if let firstEventString = filteredDateRoom.first?.event {
            eventLabel.text = firstEventString
        }
        eventLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.textColor = UIColor.systemGreen
        eventLabel.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel2 = UILabel()
        eventLabel2.text = filteredDateRoom[1].event
        eventLabel2.font = UIFont.systemFont(ofSize: 12)
        eventLabel2.textColor = UIColor.systemGreen
        eventLabel2.layer.cornerRadius = cell.bounds.width/2
        
        let eventLabel3 = UILabel()
        eventLabel3.text = filteredDateRoom[2].event
        eventLabel3.font = UIFont.systemFont(ofSize: 12)
        eventLabel3.textColor = UIColor.systemGreen
        eventLabel3.layer.cornerRadius = cell.bounds.width/2
        
        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(stackView)
        
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(cell.snp_centerXWithinMargins)
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(32)
        }
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
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let eachYear = date.year
        let eachMonth = date.month
        let eachDay = date.day
        
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        let eventCountInDateRoomList = filteredDateRoomList.last?.list.count
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let eventCountInDateRoom = filteredDateRoom.count
        
        switch eventCountInDateRoomList {
        case nil:
            deleteStackView(cell: cell)
        case 1:
            deleteStackView(cell: cell)
            makeStackViewOfOneElementByDateRoomList(cell: cell, cellDate: date)
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        case 2:
            deleteStackView(cell: cell)
            makeStackViewOfTwoElementByDateRoomList(cell: cell, cellDate: date)
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        default:
            deleteStackView(cell: cell)
            makeStackViewOfThreeElementByDateRoomList(cell: cell, cellDate: date)
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        }
        
        if eventCountInDateRoomList == nil { // イベント０の状態からの初反映処理
            
            switch eventCountInDateRoom {
            case 0: break
            case 1:
                makeStackViewOfOneElementByDateRoom(cell: cell, cellDate: date)
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            case 2:
                makeStackViewOfTwoElementByDateRoom(cell: cell, cellDate: date)
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            default:
                makeStackViewOfThreeElementByDateRoom(cell: cell, cellDate: date)
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            }
        }
    }
}

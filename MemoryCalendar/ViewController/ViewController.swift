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
    
    private func makeStackView(cell: FSCalendarCell, eventLabelText1: String?, eventLabelText2: String?, eventLabelText3: String?) {
        let eventLabel = EventNameLabel(cell: cell, eventLabelText: eventLabelText1)
        let eventLabel2 = EventNameLabel(cell: cell, eventLabelText: eventLabelText2)
        let eventLabel3 = EventNameLabel(cell: cell, eventLabelText: eventLabelText3)
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
            makeStackView(cell: cell, eventLabelText1: filteredDateRoomList.first?.list.first?.event, eventLabelText2: "", eventLabelText3: "")
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        case 2:
            deleteStackView(cell: cell)
            makeStackView(cell: cell, eventLabelText1: filteredDateRoomList.first?.list.first?.event, eventLabelText2: filteredDateRoomList.last?.list[1].event, eventLabelText3: "")
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        default:
            deleteStackView(cell: cell)
            makeStackView(cell: cell, eventLabelText1: filteredDateRoomList.first?.list.first?.event, eventLabelText2: filteredDateRoomList.last?.list[1].event, eventLabelText3: filteredDateRoomList.last?.list[2].event)
            identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
        }
        
        if eventCountInDateRoomList == nil { // イベント０の状態からの初反映処理
            
            switch eventCountInDateRoom {
            case 0: break
            case 1:
                makeStackView(cell: cell, eventLabelText1: filteredDateRoom.first?.event, eventLabelText2: "", eventLabelText3: "")
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            case 2:
                makeStackView(cell: cell, eventLabelText1: filteredDateRoom.first?.event, eventLabelText2: filteredDateRoom[1].event, eventLabelText3: "")
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            default:
                makeStackView(cell: cell, eventLabelText1: filteredDateRoom.first?.event, eventLabelText2: filteredDateRoom[1].event, eventLabelText3: filteredDateRoom[2].event)
                identifyTodayEventAndSetupNotification(date: date, year: eachYear, month: eachMonth, day: eachDay)
            }
        }
    }
}

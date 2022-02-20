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
//    private var notificationTimer = Timer()
//    let UD = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        cellReloadButton.layer.cornerRadius = 10
        cellReloadButton.addTarget(self, action: #selector(tappedCellReloadButton), for: .touchUpInside)
        identifyTodayEventAndSetupNotification()
                
//        開発用 realm全消去
//        do {
//            let realm = try Realm()
////                print(Realm.Configuration.defaultConfiguration.fileURL!)
//            try! realm.write({
//                realm.deleteAll()
//            })
//        } catch {
//        }
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
    
    private func identifyTodayEventAndSetupNotification() {
        
//        let intervalFunc = { (time: Timer) in print("intervalFunc") }
//        init() { notificationTimer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 24, repeats: false, block: <#T##(Timer) -> Void#>)}
//        Timer.sched
        
        guard let today = self.Calendar.today else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let todayString = dateFormatter.string(from: today)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(todayString)'")
        let message = filteredDateRoom.first?.event
        
        switch filteredDateRoom.count {
        case 1:
            setupNotification(message: message ?? "")
        case 2:
            if let unwrappedMessage = message {
                setupNotification(message: "1.\(unwrappedMessage)\n2.\(filteredDateRoom[1].event)")
            }
        case 3:
            if let unwrappedMessage = message {
                setupNotification(message: "1.\(unwrappedMessage)\n2.\(filteredDateRoom[1].event)\n3.\(filteredDateRoom[2].event)")
            }
        default: break
        }
    }
    
    private func setupNotification(message: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "今日のタスク(優先順)"
        content.body = message
        content.sound = UNNotificationSound.default
        
        let date = DateComponents(hour: 0, minute: 2)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        let request = UNNotificationRequest.init(identifier: "TestHours", content: content, trigger: trigger)
//        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: nil) // じさ関係ないやつ
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
//    func judgeDate() {
//
//        let calendar = Calendar.current
//        let nowDay = Date(timeIntervalSinceNow: 60 * 60 * 9)
//        var judge = Bool()
//
//        if UD.object(forKey: "today") != nil {
//            let pastDay = UD.object(forKey: "today") as! Date
//            let now = calendar.component(.day, from: nowDay)
//            let past = calendar.component(.day, from: pastDay)
//
//            if now != past {
//                judge = true
//            } else {
//                judge = false
//            }
//        } else { // 初回限定
//            judge = true
//            UD.set(nowDay, forKey: "today")
//        }
//
//        if judge == true {
//            judge = false
//        } else {
//
//        }
//    }
    
   private func makeStackViewOfOneElementByDateRoomList(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
        }
    }
    
    private func makeStackViewOfOneElementByDateRoom(cell: FSCalendarCell, cellDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: cellDate)
        let realm = try! Realm()
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        
        let eventLabel = UILabel()
        //                let eventLabel = EventLabel(frame: .zero, eventText: eventText) // リファクタリング用?
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
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
            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
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
//        print("dateString: ", dateString)

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
    }
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        let x = realm.objects(Event.self).first
//        let date = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        var hasEvent: Bool = false
//
//        for eventModel in Event
//    }
}

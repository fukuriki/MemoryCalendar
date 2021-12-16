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
//    var isFirst = Bool()
//    private let chalendarCellContentInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 60)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
//            print("string: ", string)

            setMemoryViewController.date = SettingDate.dateFromString(string: string, format: "y-MM-dd")
//            print("setMemoryViewController.date: ", setMemoryViewController.date)
            
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
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        let dateString = dateFormatter.string(from: date)
//        print("dateString: ", dateString)
        
        let realm = try! Realm()
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
        print("filteredDateRoomList: ", filteredDateRoomList)
        
        
//        let secondFilteredDateRoomList = filteredDateRoomList
        
//        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'")
//        print("filteredDateRoom: ", filteredDateRoom)
        
//        if !self.isFirst {
//        if self.isFirst { return }
        
        for listIndex in filteredDateRoomList.indices {
            
//            print("listIndex: ", listIndex)
            
            guard let eventText = filteredDateRoomList[listIndex].list.first?.event else { return }
//            二つ目のindexが原因?
//                let eventText = filteredDateRoomList[listIndex].list[dateRoomIndex].event
//            let dateRoomId = filteredDateRoomList[listIndex].dateRoomId
            print("eventText: ", eventText)
            
            let eventLabel = UILabel()
//                let eventLabel = EventLabel(frame: .zero, eventText: eventText)
            eventLabel.font = UIFont.systemFont(ofSize: 12)
            eventLabel.text = eventText
            eventLabel.textColor = UIColor.systemMint
            eventLabel.layer.cornerRadius = cell.bounds.width/2

                let eventLabel2 = UILabel()
//            let eventLabel2 = EventLabel(frame: .zero, eventText: eventText)
            eventLabel2.font = UIFont.systemFont(ofSize: 12)
            eventLabel2.text = ""
            eventLabel2.textColor = UIColor.systemMint
            eventLabel2.layer.cornerRadius = cell.bounds.width/2
//
                let eventLabel3 = UILabel()
//            let eventLabel3 = EventLabel(frame: .zero, eventText: eventText)
            eventLabel3.font = UIFont.systemFont(ofSize: 12)
            eventLabel3.text = ""
            eventLabel3.textColor = UIColor.systemMint
            eventLabel3.layer.cornerRadius = cell.bounds.width/2
            
            let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
//            if filteredDateRoomList.contains() {
//
//            }
            
            cell.addSubview(stackView)
            
            stackView.alignment = .center
            stackView.snp.makeConstraints { make in
                
                make.width.equalTo(75)
                make.height.equalTo(45)
                make.centerX.equalTo(cell.snp_centerXWithinMargins)
                make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
            }
        }
        
//        let eventInDateRoomListArray = Array(eventInDateRoomList)
//        print("eventInDateRoomListArray: ", eventInDateRoomListArray)
        
//        if eventInDateRoomList
        
//        let eventLabel = UILabel()
//        eventLabel.font = UIFont.systemFont(ofSize: 8)
//        eventLabel.text = "ぴえん"
//        eventLabel.textColor = UIColor.systemMint
//        eventLabel.layer.cornerRadius = cell.bounds.width/2
//
//        let eventLabel2 = UILabel()
//        eventLabel2.font = UIFont.systemFont(ofSize: 8)
//        eventLabel2.text = "ぴえん"
//        eventLabel2.textColor = UIColor.systemMint
//        eventLabel2.layer.cornerRadius = cell.bounds.width/2
//
//        let eventLabel3 = UILabel()
//        eventLabel3.font = UIFont.systemFont(ofSize: 8)
//        eventLabel3.text = "ぴえん"
//        eventLabel3.textColor = UIColor.systemMint
//        eventLabel3.layer.cornerRadius = cell.bounds.width/2
//
//        let stackView = UIStackView(arrangedSubviews: [eventLabel, eventLabel2, eventLabel3])
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        cell.addSubview(stackView)
//
//        stackView.alignment = .center
//        stackView.snp.makeConstraints { make in
//
//            make.width.equalTo(75)
//            make.height.equalTo(45)
//            make.centerX.equalTo(cell.snp_centerXWithinMargins)
//            make.centerY.equalTo(cell.snp_centerYWithinMargins).offset(35)
//        }
        
//        print("willDisplay")
        
//        stackView.frame.offsetBy(dx: <#T##CGFloat#>, dy: <#T##CGFloat#>)
//        stackView.frame.offsetBy(dx: 0, dy: 30)
        
//        stackView.widthAnchor.constraint(equalToConstant: 75).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

//        eventLabel.topAnchor.constraint(equalTo: )

//        eventLabel.topAnchor.constraint(equalTo: cell.centerYAnchor) + 20 = true
//        eventLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
//        eventLabel.topAnchor.constraint(equalToSystemSpacingBelow: cell.topAnchor, multiplier: 20)
//        eventLabel.centerXAnchor.constraint(equalTo: 20).isActive = true
//        eventLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
//        let stackViewDate = date
//        print(stackViewDate)
    }
    
}

//class EventLabel: UIView {
//
//    var eventLabel: UILabel?
//
//    init(frame: CGRect, eventText: String) {
//        super.init(frame: frame)
//
//        eventLabel?.font = UIFont.systemFont(ofSize: 8)
//        eventLabel?.text = eventText
//        eventLabel?.textColor = UIColor.systemMint
////        eventLabel?.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


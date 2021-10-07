//
//  ViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/23.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
//    var stringSelectedDay: String = ""
//    weak var delegate: ToPassDataProtocol?
    
    @IBOutlet weak var Calendar: FSCalendar!
    
//    fileprivate lazy var dateFormatter: DateFormatter = {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
//        return formatter
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let calPosition = Calendar.current
        
//        let selectDay = calPosition.date(from: DateComponents(year: <#T##Int?#>, month: <#T##Int?#>, day: <#T##Int?#>))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(giveDate), name: .notifyName, object: nil)

        
    }
    
    @objc private func giveDate(date: Date) {
        let date = date
        print("date: ", date)

    }

}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let setMemoryViewController = storyboard.instantiateViewController(withIdentifier: "Insert")
//        setMemoryViewController.delegate
        present(setMemoryViewController, animated: true, completion: nil)
        
//        NotificationCenter.default.post(name: .notifyName, object: nil, userInfo: ["date": date])

//        self.giveDate(date: date)
        

//        let selectedDay = "\(date)"
//        self.stringSelectedDay.append(selectedDay)
//        print("stringSelectedDay: ", stringSelectedDay)
        
//        NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>, userInfo: <#T##[AnyHashable : Any]?#>)
//        NotificationCenter.default.post("BUTTON", object: nil, userInfo: <#T##[AnyHashable : Any]?#>)
        
//        NotificationCenter.default.post(name: .notifyName, object: nil)
        

    }
}

extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}

//extension ViewController: ToPassDataProtocol {
//    func dataDidSelect(data: Date) {
////
//    }
//}

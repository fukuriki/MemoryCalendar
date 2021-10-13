//
//  ViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/23.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
//    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var Calendar: FSCalendar!
    
//    var dateFormatter: DateFormatter = {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
//        return formatter
//    }()
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self

    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let setMemoryViewController = storyboard.instantiateViewController(withIdentifier: "Insert") as? SetMemoryViewController
        
        if let setMemoryViewController = setMemoryViewController {
            
//            SettingDate().dateFormatter
//                let dateFormatter = DateFormatter()
            
//            let dateX = SettingDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd"
            let string = dateFormatter.string(from: date)
            print("string: ", string)
            
//            setMemoryViewController.date =  dateFormatterForDateLabel(date: date)
//            SettingDate.dateFromString(string: string, format: "y-MM-dd")

//            setMemoryViewController.date =  date
            setMemoryViewController.date = SettingDate.dateFromString(string: string, format: "y-MM-dd")
            
            present(setMemoryViewController, animated: true, completion: nil)
        }
    }
    
//    private func dateFormatterForDateLabel(date: Date) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
//        return date
//    }
}

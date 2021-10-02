//
//  ViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/23.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var Calendar: FSCalendar!
    
//    fileprivate lazy var dateFormatter: DateFormatter = {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
//        return formatter
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate = self
        Calendar.dataSource = self
        
    }

}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        print("tappedDateButton")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let setMemoryViewController = storyboard.instantiateViewController(withIdentifier: "Insert")
        present(setMemoryViewController, animated: true, completion: nil)
    }
}

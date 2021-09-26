//
//  SetMemoryViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/26.
//

import UIKit
import FSCalendar

class SetMemoryViewController: UIViewController {
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.backgroundColor = .blue
    }
}

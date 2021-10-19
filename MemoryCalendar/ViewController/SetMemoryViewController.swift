//
//  SetMemoryViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/26.
//

import Foundation
import UIKit
import FSCalendar
import RealmSwift

class SetMemoryViewController: UIViewController {
    
    private let cellId = "cellId"
    private var event = [Event]()
    var date = Date()
//    var date = SettingDate()

//    var dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//    var dateString = String(date)
    var editBarButtonItem: UIBarButtonItem!
    var eventList: Results<Event>!

    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "y-MM-dd"
//        let string = dateFormatter.string(from: date)
//        print("viewDidLoadのstring: ", string)
//
//        self.date = SettingDate.dateFromString(string: string, format: "y-MM-dd")
//        print("viewDidLoadのdate: ", date)
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)

        } catch {
            
        }
    }
    
    @objc private func tappedEditBarButton() {
        if setMemoryTableView.isEditing {
            print("tappedEditBarButtonf")
            setMemoryTableView.isEditing = false
        }
        else {
            print("tappedEditBarButtont")
            setMemoryTableView.isEditing = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToContainerViewController" {
            let next = segue.destination as? ContainerViewController
            next?.dateInContainer = self.date
        }
    }
}
    
extension SetMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "復習リスト"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let filteredEventList = eventList.contains(date) {
//
//        }
        
        
        
//        let dateString: String = "\(date)"
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        print("dateString: ", dateString)
        let eventListArray = Array(eventList)
//        print("eventListArray: ", eventListArray)
        
        
        
        let filteredEventListArray = eventListArray.filter {
//            $0.day.contains("2021-10-21")
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }
        
//        print("filteredEventListArray: ", filteredEventListArray)
//        eventListArray.filter { <#Event#> in
//            <#code#>
//        }
        
//        return eventListArray.count
        return filteredEventListArray.count
        
        }
        
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
//        cell.プロパティ
//        cell.reviewDayLabel.text = "aiu"
//        cell.eventTextView.text = "aiu"
//        上二つ反映された
        cell.selectionStyle = .default
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let eventListArray = Array(eventList)
//        print("eventListArray: ", eventListArray)
        
        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }
        
        print("filteredEventListArrayInCellF: ", filteredEventListArray)
//        let filteredEvent = filteredEventListArray.filter { <#Event#> in
//            <#code#>
//        }
        
        
//        do {
//            let realm = try Realm()
            
            
//            var eventList: Results<Event>!
//            eventList = realm.objects(Event.self)
            
//            eventList = realm.objects(Event.self).filter {
//
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
////                                \(dateString)
////                                || ("\(dateString)") || ("\(dateString)") || ("\(dateString)") || ("\(dateString)")
//            }
            
//            ("day = \(dateString)")
//            || realm.objects(Event.self).filter("reviwwDay1 = \(dateString)") || realm.objects(Event.self).filter("reviwwDay3 = \(dateString)") || realm.objects(Event.self).filter("reviwwDay7 = \(dateString)") || realm.objects(Event.self).filter("reviwwDay30 = \(dateString)")
            
            
//            cell.reviewDayLabel.text = eventListArray[indexPath.row].reviewDay3.key
            
//            cell.eventTextView.text = eventListArray[indexPath.row].event
//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
//            print("event: ", event)
            
            
            
//            let filteredEventListArray = eventListArray.filter {
//                $0.event.contains("ぴえん")
//            }
            cell.eventTextView.text = filteredEventListArray[indexPath.row].event


            
//        } catch {
//
//        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            var eventListArray = Array(eventList)
            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

        } catch {
            
        }
    }
}



class ContainerViewController: UIViewController {
    
    var dateInContainer = Date()

    @IBAction func tappedNewTaskButton(_ sender: Any) {
        
        popUpInterface()
    }
    
    @IBOutlet weak var newTaskButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newTaskButton.layer.cornerRadius = 35
    }
    
    private func popUpInterface() {
        
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
                    title: "復習すべきこと",
                    message: "Enter your task",
                    preferredStyle: UIAlertController.Style.alert)
        
                alert.addTextField(
                    configurationHandler: {(textField: UITextField!) in
                        alertTextField = textField
                    })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.cancel,
            handler: nil)
        
        let okAction =  UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
                            
                            let day = self.dateInContainer
//                            let day = self.dateInContainer.addingTimeInterval(60 * 60 * 24)

                            let reviewDay1 = Calendar.current.date(byAdding: .day, value: 1, to: day)
                                let reviewDay3 = Calendar.current.date(byAdding: .day, value: 3, to: day)
                                let reviewDay7 = Calendar.current.date(byAdding: .day, value: 7, to: day)
                                let reviewDay30 = Calendar.current.date(byAdding: .day, value: 30, to: day)
                            
                            do {
                                let realm = try Realm()
                                let Event = Event()
                                Event.event = alertTextField?.text ?? ""
                                Event.day = SettingDate.stringFromDate(date: day, format: "y-MM-dd")
                                Event.reviewDay1 = SettingDate.stringFromDate(date: reviewDay1!, format: "y-MM-dd")
                                Event.reviewDay3 = SettingDate.stringFromDate(date: reviewDay3!, format: "y-MM-dd")
                                Event.reviewDay7 = SettingDate.stringFromDate(date: reviewDay7!, format: "y-MM-dd")
                                Event.reviewDay30 = SettingDate.stringFromDate(date: reviewDay30!, format: "y-MM-dd")
                                 
                                try realm.write{
                                    realm.add(Event)
                                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                                }
                            } catch {
                                    print("create to do err")
                                }
                            }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
    }
}


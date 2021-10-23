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
//    let realm = try! Realm()
//    lazy var realm = try! Realm()
//    private var event = [Event]()
    var date = Date()
    var editBarButtonItem: UIBarButtonItem!
    var eventList: Results<Event>!
//    var sortedData: Results<ItemList>!
    var listedObject: List<Event>!

    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
//        listedObject = realm.objects(DateWrapper.self).first?.order
//        print("objects: ", listedObject)
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
//            編集モード中
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

        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let eventListArray = Array(eventList)
        
        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }
        
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

        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }

//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
        cell.eventTextView.text = filteredEventListArray[indexPath.row].event

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do {
                let realm = try Realm()
//                let ta = realm.objects(Event.self).first
                try realm.write({
                    realm.delete(self.eventList[indexPath.row])
                })
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAction.fade)
                setMemoryTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            } catch {
        }
            setMemoryTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
//            listedObject = realm.objects(DateWrapper.self).first?.list
//            print("listedObject: ", listedObject)
            var eventListArray = Array(eventList)
            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            
//            let dataWrapper = DataWrapper()
//                dataWrapper.list.append(objectsIn: eventList)
//                print("dataWrapper: ", dataWrapper)

//            下３行あってもなくても
//            let listItem = eventListArray[sourceIndexPath.row]
//            eventListArray.remove(at: sourceIndexPath.row)
//            eventListArray.insert(listItem, at: destinationIndexPath.row)
            
//            let dataWrapper = DataWrapper()
//            dataWrapper.list.append(objectsIn: eventListArray)
//            print("dataWrapper: ", dataWrapper)
            
            

        } catch {

        }
        
//        do {
//        let realm = try Realm()
//        let dataWrapper = DataWrapper()
//            dataWrapper.list.append(objectsIn: eventList)
//            print("dataWrapper: ", dataWrapper)

//        eventList = realm.objects(Event.self)
//            listedObject = realm.objects(DateWrapper.self).first?.order
//            print("listedObject:", listedObject)
//            var eventListArray = Array(eventList)

//        try! realm.write {
//                let listItem = listedObject[sourceIndexPath.row]
//            listedObject.remove(at: sourceIndexPath.row)
//            listedObject.insert(listItem, at: destinationIndexPath.row)
//            }
//        }
//         catch {
//
//        }
        
//        do {
//            let realm = try Realm()
//            eventList = realm.objects(Event.self)
//            var eventListArray = Array(eventList)
//
//            sortedData = realm.objects(DataWrapper.self)
//            var sortedListArray = Array(sortedData)
//            try realm.write ({
//
//                let sourceObject = listedObject[sourceIndexPath.row]
//                listedObject.remove(at: sourceIndexPath.row)
//                listedObject.insert(sourceObject, at: destinationIndexPath.row)
                
                
                //                let destinationObject = eventListArray[destinationIndexPath.row]
//                let destinationObjectOrder = destinationObject.order
//
//                if sourceIndexPath.row < destinationIndexPath.row {
//                    for index in sourceIndexPath.row...destinationIndexPath.row {
//                        let object = eventListArray[index]
//                        object.order -= 1
//                    }
//                    } else {
//                        for index in destinationIndexPath.row..<sourceIndexPath.row {
//                            let object = eventListArray[index]
//                            object.order += 1
//                    }
//                }
//                    sourceObject.order = destinationObjectOrder
//
//                         eventListArray.remove(at: sourceIndexPath.row)
//                         eventListArray.insert(sourceObject, at: destinationIndexPath.row)
//
//
//                let sourceObject = sortedListArray[sourceIndexPath.row]
//                         sortedListArray.remove(at: sourceIndexPath.row)
//                         sortedListArray.insert(sourceObject, at: destinationIndexPath.row)
//            })
//
//        } catch {
//
//        }

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
//                                    Event.list.append(objectsIn: list)
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


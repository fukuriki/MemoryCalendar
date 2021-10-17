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
    var editBarButtonItem: UIBarButtonItem!
    var eventList: Results<Event>!
//    var eventListArray = Array(eventList)

    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
//        setMemoryTableView.isEditing = true
//        setMemoryTableView.allowsSelectionDuringEditing = true
        
        
//        navigationController?.navigationItem.leftBarButtonItem = UIButton
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("aaaa")
//        setMemoryTableView.reloadData()
        
//                setMemoryTableView.isEditing = true
//                setMemoryTableView.allowsSelectionDuringEditing = true
        
//        if setMemoryTableView.isEditing {
//
//                   setMemoryTableView.isEditing = false
//               }
//               else {
//                   setMemoryTableView.isEditing = true
//               }

//        下ないと落ちる
        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)

        } catch {
//            ↓なくてもよくね？
            setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
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
//        return 20
        return eventList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
//        cell.プロパティ
//        cell.reviewDayLabel.text = "aiu"
//        cell.eventTextView.text = "aiu"
//        上二つ反映された
        cell.selectionStyle = .default
        
        do {
            let realm = try Realm()
//            var eventList: Results<Event>!
            eventList = realm.objects(Event.self)
//            eventList = Array(eventList)
            var eventListArray = Array(eventList)
            print("eventList: ", eventListArray)
            
//            cell.reviewDayLabel.text = eventListArray[indexPath.row].reviewDay3.key
            
//            func getKey(value: Int, dictionary: [String: String]) -> String? {
//
//                for (key, value) in dictionary {
//                    if value.contains(value) {
//                        return key
//                    }
//                }
//                return nil
//            }
            
            
            
//            let keys = eventListArray.keys
//            print(Array(eventListArray.keys))
            
            cell.eventTextView.text = eventListArray[indexPath.row].event
//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
            
//            func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//                eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//            }
            
        } catch {
            
//            cell.eventTextView.text = eventList[IndexPath.row].event
//            setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
//            cell.eventTextView.text = eventList[indexPath.row].event
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        setMemoryTableView.deselectRow(at: indexPath, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        print("trailingSwipeActionsConfigurationForRowAt")
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
//            completionHandler(true)
//        }
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
    
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            var eventListArray = Array(eventList)
//            print("eventList: ", eventListArray)
            
            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

        } catch {
            
        }
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        do {
//            let realm = try Realm()
//            eventList = realm.objects(Event.self)
//            var eventListArray = Array(eventList)
////            print("eventList: ", eventListArray)
//            eventListArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
////            setMemoryTableView.reloadData()
//
//        } catch {
//
//        }
//
//        let realm: Realm
//        do {
//            let realm = try Realm()
//            try realm.write() {
//                let results = realm.objects(Event.self).filter("")
////                realm.delete(results[])
//            }
//
//        } catch {
//
//        }
//
//
//
////       if (editingStyle == UITableViewCell.EditingStyle.delete) {
////        do {
////            let realm = try Realm()
//////            var eventListArray = Array(eventList)
////            try realm.write {
////                realm.delete(eventListArray[indexPath.row])
////            }
////            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
//////            setMemoryTableView.reloadData()
////        } catch {
////
////        }
////           tableView.reloadData()
////        }
//
//    }
    
//    public func delete(_ object: Object)
    
//    func   findKeyForValue(value: Int, dictionary:)

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


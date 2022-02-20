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
    var date = Date()
    var editBarButtonItem: UIBarButtonItem!
    var eventListProperty: Results<Event>!
    var list: List<DateRoom>!
    var identifierByDateRoomList: Results<DateRoomList>!
    var isFirst = Bool()
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        fetchRealmInfo()
    }
    
    private func setupUI() {
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        setMemoryTableView.estimatedRowHeight = 50
        setMemoryTableView.rowHeight = UITableView.automaticDimension
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .notifyName, object: nil)
    }
    
    private func fetchRealmInfo() {
        do {
            let realm = try Realm()
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        for lists in dateRoomListResults.indices {
            self.list = dateRoomListResults[lists].list
        }
        
            self.identifierByDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
            eventListProperty = realm.objects(Event.self)
        } catch {
            print(error)
        }
    }
    
    @objc private func tappedEditBarButton() {
        if setMemoryTableView.isEditing {
            setMemoryTableView.isEditing = false
        }
        else {
            setMemoryTableView.isEditing = true
        }
    }
    
    @objc private func reloadTableView() {
        do {
            let realm = try Realm()
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        for lists in dateRoomListResults.indices {
            self.list = dateRoomListResults[lists].list
        }
        } catch {
            
        }
        setMemoryTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToContainerViewController" {
            let next = segue.destination as? ContainerViewController
            next?.dateInContainer = self.date
            next?.identifierByDateRoomList = self.identifierByDateRoomList
        }
    }
}
    
extension SetMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "復習リスト(優先順)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        do {
            let realm = try Realm()
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
        let filteredDateRoomListCount = filteredDateRoomList.last?.list.count
        
        switch self.list {
        case nil:
            let count = filteredDateRoom.count
            return count
        default:
            return filteredDateRoomListCount ?? 0
        }
        } catch {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        do {
            let realm = try! Realm()

                
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
        
        cell.selectionStyle = .default
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let eventListArray = Array(eventListProperty)

//        選択日と合致する復習日を含むEventを取得
        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }
        
            let dateRoom = DateRoom()
        let dateRoomList = DateRoomList()
        
//            選択日とEvent名が合致するdateRoomIdを持つDateRoomを取得
        let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
        
        if secondFilteredDateRoomResult.isEmpty == true && self.isFirst { // 初回処理
            
                try! realm.write{
                    
                    if self.identifierByDateRoomList.isEmpty == true {
//                        dateStringと一致するdateRoomlistがない
                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                        dateRoomList.list.append(dateRoom)
                        realm.add(dateRoomList)

                        } else {

//                            dateStringと一致するdateRoomlistがある。filterし直す必要ありぽだから再度filter描いてる
                            if self.identifierByDateRoomList.filter("dateRoomId == '\(dateString)'").isEmpty == false {
                                let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'").last
                                    dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                                dateRoomListLast?.list.append(dateRoom)
                            }
                        }
                }
            
//            今世紀最大の謎
            setMemoryTableView.reloadData()
            
        } else { // 二回目以降の処理 &　新規追加データ？

            try! realm.write{
            
            if self.identifierByDateRoomList.isEmpty == true {

                dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                dateRoomList.list.append(objectsIn: filteredDateRoomResult)
                realm.add(dateRoomList)
                let dateRoomListResult = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                for lists in dateRoomListResult.indices {
                    self.list = dateRoomListResult[lists].list
                    let indicedDateRoomListOrder = dateRoomListResult[lists].list[indexPath.row].order
                    let indicedDateRoomListEvent = dateRoomListResult[lists].list[indexPath.row].event
                    cell.priorityLabel.text = String(indicedDateRoomListOrder)
                    cell.eventTextView.text = indicedDateRoomListEvent
                }
                
            } else {

                    let dateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
                    let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'").last
                    
                    if dateRoomResult.count != dateRoomListLast?.list.count {
                        dateRoomListLast?.list.removeAll()
                        dateRoomListLast?.list.append(objectsIn: dateRoomResult)
                    }

                    let dateRoomListResult = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    for lists in dateRoomListResult.indices {
                        self.list = dateRoomListResult[lists].list
                        let indicedDateRoomListOrder = dateRoomListResult[lists].list[indexPath.row].order
                        let indicedDateRoomListEvent = dateRoomListResult[lists].list[indexPath.row].event
                        cell.priorityLabel.text = String(indicedDateRoomListOrder)
                        cell.eventTextView.text = indicedDateRoomListEvent
                    }
                }
            }
            }
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                        
        if editingStyle == UITableViewCell.EditingStyle.delete {

            do {
                let realm = try Realm()
                let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
                
                try! realm.write({
                    
                    let selfListArray = Array(self.list)
                    let selfListArrayIndexPath = selfListArray[indexPath.row]
                    let event = selfListArrayIndexPath.event
                    let selectedDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'").filter("event == '\(event)'")
                    realm.delete(selectedDateRoom)
                    
                    let dateRoomListCount = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'").first?.list.count
                    let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    if dateRoomListCount == 0 {
                        realm.delete(filteredDateRoomList)
                    }
                })
            setMemoryTableView.reloadData()
            } catch {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        do {
            let realm = try Realm()
        
            try! realm.write({
                let listItem = list[sourceIndexPath.row]
                list.remove(at: sourceIndexPath.row)
                list.insert(listItem, at: destinationIndexPath.row)
            })
        } catch {
            
        }
    }
}



class ContainerViewController: UIViewController {
    
    var dateInContainer = Date()
    let realm = try! Realm()
    var identifierByDateRoomList: Results<DateRoomList>!
    weak var delegate: ToPassDataProtocol?
    var inputString = ""


    @IBAction func tappedNewTaskButton(_ sender: Any) {
        
        popUpInterface()
    }
    
    @IBOutlet weak var newTaskButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newTaskButton.layer.cornerRadius = 35
        let dateString = SettingDate.stringFromDate(date: self.dateInContainer, format: "y-MM-dd")
        self.identifierByDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")

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

                            let reviewDay1 = Calendar.current.date(byAdding: .day, value: 1, to: day)
                                let reviewDay3 = Calendar.current.date(byAdding: .day, value: 3, to: day)
                                let reviewDay7 = Calendar.current.date(byAdding: .day, value: 7, to: day)
                                let reviewDay30 = Calendar.current.date(byAdding: .day, value: 30, to: day)
                
                let dateString = SettingDate.stringFromDate(date: day, format: "y-MM-dd")
                let filteredDateRoomResult = self.realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")

                            do {
                                let realm = try Realm()
                                let Event = Event()
                                let dateRoom = DateRoom()
                                let dateRoom1 = DateRoom()
                                let dateRoom3 = DateRoom()
                                let dateRoom7 = DateRoom()
                                let dateRoom30 = DateRoom()
                                let dateRoomList = DateRoomList()

                                Event.event = alertTextField?.text ?? ""
                                Event.day = SettingDate.stringFromDate(date: day, format: "y-MM-dd")
                                Event.reviewDay1 = SettingDate.stringFromDate(date: reviewDay1!, format: "y-MM-dd")
                                Event.reviewDay3 = SettingDate.stringFromDate(date: reviewDay3!, format: "y-MM-dd")
                                Event.reviewDay7 = SettingDate.stringFromDate(date: reviewDay7!, format: "y-MM-dd")
                                Event.reviewDay30 = SettingDate.stringFromDate(date: reviewDay30!, format: "y-MM-dd")
                                
                                dateRoom.event = Event.event
                                dateRoom.dateRoomId = SettingDate.stringFromDate(date: day, format: "y-MM-dd")
                                dateRoom1.event = Event.event
                                dateRoom1.dateRoomId = SettingDate.stringFromDate(date: reviewDay1!, format: "y-MM-dd")
                                dateRoom3.event = Event.event
                                dateRoom3.dateRoomId = SettingDate.stringFromDate(date: reviewDay3!, format: "y-MM-dd")
                                dateRoom7.event = Event.event
                                dateRoom7.dateRoomId = SettingDate.stringFromDate(date: reviewDay7!, format: "y-MM-dd")
                                dateRoom30.event = Event.event
                                dateRoom30.dateRoomId = SettingDate.stringFromDate(date: reviewDay30!, format: "y-MM-dd")

                                try realm.write{
                                    realm.add(Event)
                                    realm.add(dateRoom)
                                    realm.add(dateRoom1)
                                    realm.add(dateRoom3)
                                    realm.add(dateRoom7)
                                    realm.add(dateRoom30)
                                    
                                    if self.identifierByDateRoomList.isEmpty == true {
                                        
                                        for index in filteredDateRoomResult.indices {

                                        dateRoomList.dateRoomId = filteredDateRoomResult[index].dateRoomId
                                        dateRoomList.list.append(dateRoom)
                                        realm.add(dateRoomList)
                                        }

                                        } else {
                                            
                                            let dateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
                                            let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'").last
                                            
                                            if dateRoomResult.count != dateRoomListLast?.list.count {
                                                dateRoomListLast?.list.removeAll()
                                                dateRoomListLast?.list.append(objectsIn: dateRoomResult)
                                            }
                                        }
                                }
                                NotificationCenter.default.post(name: .notifyName, object: nil)
                            } catch {
                                    print("create to do err")
                                }
                            }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func changeTextField(sender: NSNotification, okAction: UIAlertAction) {
        
        let textField = sender.object as! UITextField
        
        self.inputString = textField.text ?? ""
        
        if self.inputString.count < 1 {
            okAction.isEnabled = false
        }
    }
}

extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}

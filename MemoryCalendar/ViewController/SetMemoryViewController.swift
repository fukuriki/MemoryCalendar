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
    var eventList: Results<Event>!
    var dateRoomListProperty: Results<DateRoom>!
    var eventString: String?
    var tappedFilteredDateRoomResultProperty: Results<DateRoom>!
    var list: List<DateRoom>!
    var identifier: Results<DateRoomList>!
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem

        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let realm = try! Realm()
        let dateRoomList = realm.objects(DateRoomList.self)
        for lists in dateRoomList.indices {
            self.list = dateRoomList[lists].list
        }
        
        self.identifier = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            dateRoomListProperty = realm.objects(DateRoom.self) // 無いとdelegateメソッド内でnilなる
        } catch {

        }
    }
    
    @objc private func tappedEditBarButton() {
        if setMemoryTableView.isEditing {
            setMemoryTableView.isEditing = false
        }
        else {
//            編集モード中
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

        do {
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let eventListArray = Array(eventList)
            
            let filteredEventListArray = eventListArray.filter {
                $0.day.contains("\(dateString)")
                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
            }
        return filteredEventListArray.count
        }
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
        
        cell.selectionStyle = .default
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let eventListArray = Array(eventList)

//        選択日と合致する復習日を含むEventを取得
        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }

//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
        eventString = filteredEventListArray[indexPath.row].event
        cell.eventTextView.text = eventString
        
            let realm = try! Realm()
            let dateRoom = DateRoom()
        let dateRoomList = DateRoomList()
        
//            選択日と合致するdateRoomIdを持つDateRoomを取得
        let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
        
        if secondFilteredDateRoomResult.isEmpty == true { // 初回処理
                        
                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString

                try! realm.write{
                    realm.add(dateRoom)
                    
                    do {
                        let filteredDateRoomResultArray = Array(filteredDateRoomResult)
                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
                    }
                                        
                    if self.identifier.isEmpty == true {
                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                        dateRoomList.list.append(dateRoom)
                            realm.add(dateRoomList)
                        } else {
                            
                            if self.identifier.filter("dateRoomId contains '\(dateString)'").isEmpty == false {

                                let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last
                                    dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                                dateRoomListLast?.list.append(dateRoom)
                            }
                        }
                    
                    let dateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    for lists in dateRoomList.indices {
                        self.list = dateRoomList[lists].list
                    }
                }
            
//            今世紀最大の謎
            setMemoryTableView.reloadData()
            
        } else { // 二回目以降の処理
            
            let dateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
            for lists in dateRoomList.indices {
                self.list = dateRoomList[lists].list
                let indicedDateRoomListOrder = dateRoomList[lists].list[indexPath.row].order
                let indicedDateRoomListEvent = dateRoomList[lists].list[indexPath.row].event
                cell.eventTextView.text = indicedDateRoomListEvent
                cell.priorityLabel.text = String(indicedDateRoomListOrder)
            }
            }
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do {
                let realm = try Realm()

                try realm.write({
                    realm.delete(eventList[indexPath.row])
                    realm.delete(dateRoomListProperty)

                })
                setMemoryTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            } catch {
        }
            setMemoryTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
            print("filteredDateRoomResultInM: ", filteredDateRoomResult)

            try! realm.write({
                let listItem = list[sourceIndexPath.row]
                list.remove(at: sourceIndexPath.row)
                list.insert(listItem, at: destinationIndexPath.row)
            })
        } catch {
            print("エラーですぞ")
        }
    }
}



class ContainerViewController: UIViewController {
    
    var dateInContainer = Date()
    weak var delegate: ToPassDataProtocol?

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


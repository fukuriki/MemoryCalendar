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
        let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
        for lists in dateRoomListResults.indices {
            self.list = dateRoomListResults[lists].list
            print("self.list: ", self.list ?? [])
        }
        
        self.identifier = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
        
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: .notifyName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("viewWillAppear")

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            dateRoomListProperty = realm.objects(DateRoom.self) // 無いとdelegateメソッド内でnilなる
        } catch {

        }
    }
    
    @objc private func doSomething() {
        
//        setMemoryTableView.reloadData()
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
        
//            選択日とEvent名が合致するdateRoomIdを持つDateRoomを取得
        let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
        
        if secondFilteredDateRoomResult.isEmpty == true { // 初回処理
            
            print("初回（イベント追加前？）")

                try! realm.write{
                    
                    do {
                        let filteredDateRoomResultArray = Array(filteredDateRoomResult)
                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
                    }
                                        
                    if self.identifier.isEmpty == true {
                        
                        print("dateStringと一致するdateRoomlistがない")
                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                        dateRoomList.list.append(dateRoom)
                            realm.add(dateRoomList)
                        
                        } else {
                            
                            print("dateStringと一致するdateRoomlistがある")
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
            
            print("二回目以降（イベント追加後？）")
                        
            try! realm.write{
            
            if self.identifier.isEmpty == true {
                
                print("dateStringと一致するdateRoomlistがない2")
                dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                dateRoomList.list.append(objectsIn: filteredDateRoomResult)
                realm.add(dateRoomList)
                
                } else {
                    
//                    ここ修正？
                    print("dateStringと一致するdateRoomlistがある2")
//                    if self.identifier // この識別文要らなくね
//                        .filter("dateRoomId contains '\(dateString)'")
//                        .isEmpty == false {
                        
                    let dateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'")
                    print("dateRoomResult: ", dateRoomResult)
                    
//                    print("dateRoomResult.count: ", dateRoomResult.count)
                    
                    
                    
                    let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last
//                    print("dateRoomListLast: ", dateRoomListLast ?? "")
//                    print("dateRoomListLast.count: ", dateRoomListLast?.list.count ?? 0)
                    print("dateRoomListLast.list: ", dateRoomListLast?.list ?? [])

//                    let dateRoomListLastx = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last?.list.last
//                    print("dateRoomListLastx: ", dateRoomListLastx ?? [])


//                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
//                    print("dateRoom: ", dateRoom)
                    
                    if dateRoomResult.count != dateRoomListLast?.list.count {
                        dateRoomListLast?.list.removeAll()
                        dateRoomListLast?.list.append(objectsIn: dateRoomResult)
//                        dateRoomListLast?.list = dateRoomResult[indexPath.row].list
//                        dateRoomListLast?.list.append(dateRoom)
//                        dateRoomListLast?.list.append(objectsIn: dateRoomResult)
                        

                    }
//                    if dateRoomResult.isEmpty == false && dateRoomListLast
//                    dateRoomListLast?.list.last?.update()
//                    dateRoomListLast?.list.append(objectsIn: dateRoomResult)
//                    dateRoomListLast?.list.append(dateRoom)
                    
                    
                    let dateRoomListResult = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    for lists in dateRoomListResult.indices {
                        self.list = dateRoomListResult[lists].list // これの意味なんなん
                        print("self.listIn二回目: ", self.list ?? [])
                        let indicedDateRoomListOrder = dateRoomListResult[lists].list[indexPath.row].order
                        let indicedDateRoomListEvent = dateRoomListResult[lists].list[indexPath.row].event // ココだー！！！！！
                        cell.priorityLabel.text = String(indicedDateRoomListOrder)
                        cell.eventTextView.text = indicedDateRoomListEvent
                    }
                    
//                    let dateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//                    for lists in dateRoomList.indices {
//                        self.list = dateRoomList[lists].list // これの意味なんなん
//                        print("self.listIn二回目: ", self.list ?? [])
//                        let indicedDateRoomListOrder = dateRoomList[lists].list[indexPath.row].order
//                        let indicedDateRoomListEvent = dateRoomList[lists].list[indexPath.row].event // ココだー！！！！！
//                        cell.priorityLabel.text = String(indicedDateRoomListOrder)
//                        cell.eventTextView.text = indicedDateRoomListEvent
//                    }
                    
//                    } //要らなくね
                }
            }
            
//            setMemoryTableView.reloadData()
            
//            こっから下で落ちてる？
//            let dateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//            for lists in dateRoomList.indices {
//                self.list = dateRoomList[lists].list
//                let indicedDateRoomListOrder = dateRoomList[lists].list[indexPath.row].order
//                let indicedDateRoomListEvent = dateRoomList[lists].list[indexPath.row].event // ココだー！！！！！
//                cell.eventTextView.text = indicedDateRoomListEvent
//                cell.priorityLabel.text = String(indicedDateRoomListOrder)
//            }
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
        
//        let specialAction = UIAlertAction(title: "Special", style: UIAlertAction.Style., handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
        
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
                            
                            do {
                                let realm = try Realm()
                                let Event = Event()
                                let dateRoom = DateRoom()
                                let dateRoom1 = DateRoom()
                                let dateRoom3 = DateRoom()
                                let dateRoom7 = DateRoom()
                                let dateRoom30 = DateRoom()

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
                                }
                                
                                NotificationCenter.default.post(name: .notifyName, object: nil)
//                                setMemoryTableView.reloadData()
                            } catch {
                                    print("create to do err")
                                }
                            }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}

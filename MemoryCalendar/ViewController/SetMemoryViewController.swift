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
    var dateRoomProperty: Results<DateRoom>!
    var dateRoomListProperty: Results<DateRoomList>!
    var eventString: String?
    var tappedFilteredDateRoomResultProperty: Results<DateRoom>!
    var list: List<DateRoom>!
    var identifierByDateRoomList: Results<DateRoomList>!
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem

//        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        let realm = try! Realm()
//        let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//        for lists in dateRoomListResults.indices {
//            self.list = dateRoomListResults[lists].list
//            print("self.list: ", self.list ?? [])
//        }
//
//        self.identifier = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .notifyName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")

        do {
            let realm = try Realm()
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
            for lists in dateRoomListResults.indices {
                self.list = dateRoomListResults[lists].list
                print("self.listInAppear: ", self.list ?? [])
            }
            
            self.identifierByDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
            
            eventList = realm.objects(Event.self)
            dateRoomProperty = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'") // 無いとdelegateメソッド内でnilなる
//            print("dateRoomProperty: ", dateRoomProperty ?? [])
            dateRoomListProperty = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//            print("dateRoomListProperty: ", dateRoomListProperty ?? [])
        } catch {

        }
//        setMemoryTableView.reloadData()
    }
    
    @objc private func reloadTableView() {
        
        let realm = try! Realm()
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let dateRoomListResults = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
        for lists in dateRoomListResults.indices {
            self.list = dateRoomListResults[lists].list
//            print("self.list: ", self.list ?? [])
        }
                
//        setMemoryTableView.beginUpdates()
//        setMemoryTableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
        setMemoryTableView.reloadData()
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
        
        print("numberOfRowsInSection")
        
        let realm = try! Realm()
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        
//        let eventListArray = Array(eventList)
//        print("eventListArray: ", eventListArray)

//        let filteredEventListArray = eventListArray.filter {
//            $0.day.contains("\(dateString)")
//            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//        }
        
        let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        print("filteredDateRoom: ", filteredDateRoom) // 無限増殖
        
        let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//        print("filteredDateRoomList: ", filteredDateRoomList )

        let filteredDateRoomListLastList = filteredDateRoomList.last?.list
        print("filteredDateRoomListLastList: ", filteredDateRoomListLastList ?? [])

        let filteredDateRoomListCount = filteredDateRoomList.last?.list.count
        print("filteredDateRoomListCount: ", filteredDateRoomListCount ?? 0 )
        
        switch self.list {
        case nil:
            print("nilなself.list")
            return filteredDateRoom.count
//            return filteredDateRoomListCount ?? 0
//            return filteredEventListArray.count
        default:
            print("nilじゃないself.list")
            return filteredDateRoomListCount ?? 0
        }
        
        
//        switch filteredDateRoom.count {
//        case 0:
//            print("0")
//            return filteredEventListArray.count
////            return filteredDateRoom.count
//        default:
//            print("0じゃない")
//            return filteredDateRoomListCount ?? 0
//        }
        
        
//        switch filteredDateRoomListCount {
//        case nil:
//            print("filteredDateRoomListCountがニル")
//            return filteredDateRoom.count
////        case 1..<Int.max:
////            return filteredDateRoomListCount ?? 0
//        default:
//            print("ニルじゃない")
////            return filteredEventListArray.count
//            return filteredDateRoomListCount!
////            break
//        }
        
//        return filteredDateRoom.count
//        return filteredDateRoomListCount ?? 0
        
//        if filteredDateRoomListCount == 0 {
//        do {
            
//            print("filteredDateRoomListCountが0")
            
//            let eventListArray = Array(eventList)
//            print("eventListArray: ", eventListArray)
//
//            let filteredEventListArray = eventListArray.filter {
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//            }
//            return filteredEventListArray.count
//        }
            
//        } else {
//            print("filteredDateRoomListCountが0じゃない")
//            return filteredDateRoomListCount ?? 0;
//        }
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt")
        
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
        
        cell.selectionStyle = .default
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let eventListArray = Array(eventList)

//        選択日と合致する復習日を含むEventを取得
        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }
//        print("filteredEventListArray: ", filteredEventListArray)

//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
//        eventString = filteredEventListArray[indexPath.row].event
                
//        let x = dateRoomListProperty[indexPath.row].list[indexPath.row].event
//        print("dateRoomListProperty[indexPath.row].list[indexPath.row].event: ", x)
//        cell.eventTextView.text = dateRoomListProperty[indexPath.row].list[indexPath.row].event
//        cell.eventTextView.text = eventString
        

//        cell.eventTextView.text = eventString
//        print("eventStringInCell: ", eventString ?? "")
        
            let realm = try! Realm()
            let dateRoom = DateRoom()
        let dateRoomList = DateRoomList()
        
//            選択日とEvent名が合致するdateRoomIdを持つDateRoomを取得
        let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
        print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
        print("self.list: ", self.list ?? [])
        
        if secondFilteredDateRoomResult.isEmpty == true { // 初回処理　&　新規追加データ？
            
            print("初回（イベント追加前？）")

                try! realm.write{
                    
//                    do {
//                        let filteredDateRoomResultArray = Array(filteredDateRoomResult)
//                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
//                    }
                                        
                    if self.identifierByDateRoomList.isEmpty == true {
                        
                        print("empty")
                        
//                        print("dateStringと一致するdateRoomlistがない")
                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                        dateRoomList.list.append(dateRoom)
                        realm.add(dateRoomList)
                        
                        } else {
                            
                            print("Noempty")
                            
//                            print("dateStringと一致するdateRoomlistがある")。filterし直す必要ありぽだから再度filter描いてる
                            if self.identifierByDateRoomList.filter("dateRoomId contains '\(dateString)'").isEmpty == false {
                                
                                print("NoNoempty")
                                
                                let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last
                                    dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                                dateRoomListLast?.list.append(dateRoom)
                                
//                                cell.eventTextView.text = self.list[indexPath.row].event
//                                cell.eventTextView.text = filteredDateRoomResult[indexPath.row].event
//                                cell.eventTextView.text = secondFilteredDateRoomResult[indexPath.row].event
//                                cell.eventTextView.text = filteredEventListArray[indexPath.row].event
//                                cell.eventTextView.text = dateRoomListLast?.list[indexPath.row].event
                            }
                        }
                    
//                    let dateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//                    for lists in dateRoomList.indices {
//                        self.list = dateRoomList[lists].list
//                        print("self.list初回末: ", self.list ?? [])
//                    }
                }
            
//            今世紀最大の謎
            setMemoryTableView.reloadData()
            
        } else { // 二回目以降の処理
            
            print("二回目以降（イベント一つでも追加済み？）")
                        
            try! realm.write{
            
            if self.identifierByDateRoomList.isEmpty == true {
                
//                print("empty2")
                
//                print("dateStringと一致するdateRoomlistがない2")
                dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                dateRoomList.list.append(objectsIn: filteredDateRoomResult)
                realm.add(dateRoomList)
                
                } else {
                    
//                    print("Noempty2")
                    
//                    print("dateStringと一致するdateRoomlistがある2")
                        
                    let dateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId contains '\(dateString)'")
//                    print("dateRoomResult: ", dateRoomResult)
                    
                    let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last
//                    print("dateRoomListLast.list: ", dateRoomListLast?.list ?? [])
                    
                    if dateRoomResult.count != dateRoomListLast?.list.count {
                        dateRoomListLast?.list.removeAll()
                        dateRoomListLast?.list.append(objectsIn: dateRoomResult)
                    }

                    let dateRoomListResult = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    for lists in dateRoomListResult.indices {
                        self.list = dateRoomListResult[lists].list
//                        print("self.listIn二回目: ", self.list ?? [])
                        let indicedDateRoomListOrder = dateRoomListResult[lists].list[indexPath.row].order
                        let indicedDateRoomListEvent = dateRoomListResult[lists].list[indexPath.row].event
                        cell.priorityLabel.text = String(indicedDateRoomListOrder)
//                        print("indicedDateRoomListEvent: ", indicedDateRoomListEvent)
                        cell.eventTextView.text = indicedDateRoomListEvent
                    }
                }
            }
//            setMemoryTableView.reloadData()
            }
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        setMemoryTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do {
                let realm = try Realm()
                let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
                
//                let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
//                print("filteredDateRoomList: ", filteredDateRoomList)
//                let eventListArray = Array(eventList)
//                let filteredEventListArray = eventListArray.filter {
//                    $0.day.contains("\(dateString)")
//                    || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//                }
//                print("filteredEventListArray: ", filteredEventListArray)
                
//                print("eventString: ", eventString ?? "")
                
                
                
//                let filteredDateRoomByEventAndDate = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//                    .filter("event == '\(filteredDateRoomList[indexPath.row].))'")

//                let filteredDateRoomByEventAndDate = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'").filter("event == '\(filteredEventListArray[indexPath.row].event))'")
//                print("filteredDateRoomByEventAndDate: ", filteredDateRoomByEventAndDate)
                
                try realm.write({
                    
                    let array = Array(self.list)
                    let arrayIndexPath = array[indexPath.row]
                    print("arrayIndexPath: ", arrayIndexPath)
                    self.list.remove(at: indexPath.row)
                    print("self.list: ", self.list ?? [])
                    
                    let filteredDateRoomList = realm.objects(DateRoomList.self).filter("dateRoomId == '\(dateString)'")
                    print("filteredDateRoomList: ", filteredDateRoomList)
                    
//                    realm.delete(arrayIndexPath)
                    
                    let x = arrayIndexPath.event
                    let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'").filter("event == '\(x)'")
                    print("filteredDateRoom: ", filteredDateRoom)
                    
                    realm.delete(arrayIndexPath)
                    realm.delete(filteredDateRoom)
                    
//                    let eventId = filteredDateRoomList.index
                    
//                    let filteredDateRoom = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
////                    .filter("event == '\(<#Any.Type#>)'")
//                    print("filteredDateRoom: ", filteredDateRoom)
//
//                    for index in filteredDateRoom.indices {
//                        let eventID = filteredDateRoomList[indexPath.row].list[index].event
//                        print("eventID: ", eventID)
//                    }
                    
//                    let eventId = self.list[indexPath.row]
//                    let eventId = filteredDateRoomList[indexPath.row]
//                    print("eventId: ", eventId)
                    
//                    for eventId in filteredDateRoom {
//                        let eventIdConst = filteredDateRoom.filter("event == '\(<#Any.Type#>)'")
//                    }
                    
//                    realm.delete(filteredDateRoom[indexPath.row])
                    
                    
//                    realm.delete(filteredDateRoomList[indexPath.row])
//                    realm.delete(filteredDateRoomList[indexPath.row])
//                    self.dateRoomListProperty.realm?.delete(filteredDateRoomList[indexPath.row])
                    
//                    realm.delete(eventList[indexPath.row])
//                    realm.delete(dateRoomListProperty[indexPath.row])
//                    print("dateRoomListProperty: ", dateRoomListProperty ?? [])
//                    realm.delete(filteredDateRoomByEventAndDate)

                })
//                setMemoryTableView.deleteRows(at: [indexPath], with: .automatic)
//                setMemoryTableView.deleteRows(at: [indexPath], with: .fade)
//                setMemoryTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)

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

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
//import SwiftUI

class SetMemoryViewController: UIViewController {
    
//    weak var delegate
    private let cellId = "cellId"
    var date = Date()
    var editBarButtonItem: UIBarButtonItem!
    var eventList: Results<Event>!
    var dateRoomListProperty: Results<DateRoom>!
    var eventString: String?
//    var dateRoomResultProperty: Results<DateRoom>!
//    var dateRoomIndexPathRow: DateRoom!
    var tappedFilteredDateRoomResultProperty: Results<DateRoom>!
//    var tableViewOrder = Int()
//    var filteredDateRoomResultArray: Array? = []
//    var moveRowToTappedEditButton = Int()
//    static var filteredDateRoomResultArray = [Results<DateRoom>]()
    var list: List<DateRoom>!
//    var listArray = Array<Any>()
    var isFirst = Bool()
    var identifier: Results<DateRoomList>!
//    var identifier = [Any]()
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        
//        デフォ
//        let realm = try! Realm()
//        self.list = realm.objects(DateRoomList.self).first?.list
//        print("listInViewDidLoad: ", self.list ?? "")

        
//        全取得パターン
        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
        let realm = try! Realm()
        let dateRoomList = realm.objects(DateRoomList.self)
//        self.list = dateRoomList.indices
        for lists in dateRoomList.indices {
//            print("dateRoomList: ", dateRoomList)
//            ↓ここでfilterすると空listになる
//            let filteredDateRoomList = dateRoomList.filter("dateRoomId contains '\(dateString)'")
//            print("filteredDateRoomList: ", filteredDateRoomList)
            
//            self.list = dateRoomList.filter("dateRoomId contains '\(dateString)'")[lists].list
            self.list = dateRoomList[lists].list
//            self.listArray = Array(self.list)

            
//            dateRoomList[lists].list
//                .filter("dateRoomId contains '\(dateString)'")[lists].list
//                .filter("dateRoomId contains '\(dateString)'")
//            self.list = dateRoomList[lists] as! List<DateRoom>
            
//            print("self.listInViewDidRow: ", self.list ?? "")
//            print("listArray: ", self.listArray)
//            print("lists: ", lists)
        }
        
        self.identifier = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'")
//        self.identifier = Array(realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'"))
        print("identifier: ", self.identifier ?? "" )

        
        
//        ２日（一つ目）のDateRoomList取得
//        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        let realm = try! Realm()
//            self.list = realm.objects(DateRoomList.self)
//            .filter("dateRoomId contains '\(dateString)'")
//            .first?.list
        
        
//        self.listArray = Array(_immutableCocoaArray: self.list)
//        print("self.listArray: ", self.listArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            let realm = try Realm()
//            var eventList: Results<Event>!
            eventList = realm.objects(Event.self)
            dateRoomListProperty = realm.objects(DateRoom.self) // 無いとdelegateメソッド内でnilなる
        } catch {

        }
    }
    
    @objc private func tappedEditBarButton() {
        if setMemoryTableView.isEditing {
            print("tappedEditBarButtonf")
            setMemoryTableView.isEditing = false
            
            do {
                let realm = try Realm()
                let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")

                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
                print("filteredDateRoomResultInEditBarButton: ", filteredDateRoomResult) // 値型だから今はただのコピー
                
//                if let indexPaths = setMemoryTableView.indexPathsForVisibleRows {
//                for indexPath in indexPaths {
//                }
//                }
            } catch {
                
            }
           
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
    
    private func testMethod() {
        print("testtest")
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
        
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
//        cell.fetchCurrentIndexInfo = {
//            self.fetchCurrentIndexInfo(cell: cell)
//        }
        
//        cell.プロパティ
//        cell.reviewDayLabel.text = "aiu"
//        cell.eventTextView.text = "aiu"
//        上二つ反映された
        
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
//            print("filteredDateRoomResult: ", filteredDateRoomResult)
        
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
//        print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
        
//        var filteredDateRoomResultArray = Array(filteredDateRoomResult)
        
//        let dateRoomListResult = realm.objects(DateRoomList.self)
//        print("dateRoomListResult: ", dateRoomListResult)
        
//        let filteredDateRoomListResult = dateRoomListResult.filter("dateRoomId contains '\(dateString)'")
//        print("filteredDateRoomListResult: ", filteredDateRoomListResult)
        
//        let filteredDateRoomListResultArray = Array(filteredDateRoomListResult)
//        print("filteredDateRoomListResultArray: ", filteredDateRoomListResultArray)
        
        
//        print("self.list.filter: ", self.list.filter("dateRoomId contains '\(dateString)'"))
        
        if secondFilteredDateRoomResult.isEmpty == true { // 初回処理
            
                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString

                try! realm.write{
                    realm.add(dateRoom)
                    
                    do {
                        let filteredDateRoomResultArray = Array(filteredDateRoomResult)
                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
                    }
                    
//                    viewDidLoadへ?
//                    let filteredIndicedDateRoomList = self.list.filter("dateRoomId contains '\(dateString)'")
//                    print("filteredIndicedDateRoomList: ", filteredIndicedDateRoomList)
                    
//                    12/3 10:35
//                    for index in filteredIndicedDateRoomList.indices {
//                    for index in self.list.indices {
//                        print("index: ", index)
                        
//                        let indicedDateRoomList = filteredIndicedDateRoomList[index].list
//                        print("indicedDateRoomList: ", indicedDateRoomList)
//
//                        let filteredIndicedDateRoomList = indicedDateRoomList.filter("dateRoomId contains '\(dateString)'")
//                        print("filteredIndicedDateRoomList: ", filteredIndicedDateRoomList)

//                                if !self.isFirst { return }
//                                print("First")
                    
                    if self.identifier.isEmpty == true
//                    if listArray.filter("dateRoomId contains '\(dateString)'").isEmpty == true
//                        if self.list.filter("dateRoomId contains '\(dateString)'").isEmpty == true
//                            && !self.isFirst
//                        if self.list == nil
                        {
//                            if !self.isFirst { return }
//                            print("First")
                        print("identifierから: ", self.identifier ?? "" )
//                            dateRoomList.dateRoomId = dateString
                        dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                            print("dateRoom: ", dateRoom)
//                        let dateRoomListLast = dateRoomList.list.filter("dateRoomId contains '\(dateString)'").last
                        dateRoomList.list.append(dateRoom)
//                            dateRoomList.list.append(dateRoom)
                            realm.add(dateRoomList)
                            
//                            var x = realm.objects(DateRoomList.self)
//                            print("dateRoomList.list.last: ", dateRoomList.list.last)
//                            x.last?.list = dateRoomList.list.last
//                            dateRoomList.list.append(x.)
//                            dateRoomList.list.append(dateRoomList.list.last!) // 二重保存
                            
                            
                            
    //                        self.list = realm.objects(DateRoomList.self).first?.list
    //                        self.list = realm.objects(DateRoomList.self).last?.list
    //                        print("listInから: ", list ?? "")
                            
                        } else {
                            print("identifierからじゃない:: ", self.identifier ?? "" )
                            
                            if self.identifier.filter("dateRoomId contains '\(dateString)'").isEmpty == false {
                                print("えんぷてぃーふぉるす")
                                print("dateRoom: ", dateRoom)
                                let dateRoomListLast = realm.objects(DateRoomList.self).filter("dateRoomId contains '\(dateString)'").last
                                print("dateRoomListLast: ", dateRoomListLast)
//                                let dateRoomListLast = dateRoomList.list.filter("dateRoomId contains '\(dateString)'").last
//                                print("dateRoomListLast: ", dateRoomListLast)
                                
                                    dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
                                dateRoomListLast?.list.append(dateRoom)
//                                    dateRoomList.list.append(dateRoom)
//                                dateRoomList.dateRoomId = filteredDateRoomResult[indexPath.row].dateRoomId
//                                dateRoomList.list.append(dateRoom)
//                                dateRoomList.list.append(dateRoomListLast)
                            }
                            
//                            dateRoomList.dateRoomId = dateString
//                            if self.isFirst {}
//                            dateRoomList.list.append(dateRoom)
//                            self.list.append(dateRoom)
                            
                        }
//                    }
//                    12/3 10:35
                    
                    
//                    let filteredDateRoomListResultArray = dateRoomListResultArray.filter
////                    ("dateRoomId CONTAINS '\(dateString)'")
//                    {
//                        $0.dateRoomId.contains("\(dateString)")
//                    }
//
//                    print("filteredDateRoomListResultArray: ", filteredDateRoomListResultArray)

//                    if self.list == true
//                    if self.list.filter("dateRoomId contains '\(dateString)'").isEmpty == true
//                    if filteredDateRoomListResult == nil
//                    if filteredDateRoomListResult.isEmpty == true
//                    if dateRoomListResult.contains("\(dateString)")
//                    if self.list.contains()
                    
                    
//                    if self.list == nil
//                    {
////                        print("self.list.filter: ", self.list.filter("dateRoomId contains '\(dateString)'"))
//                        print("から")
//                        dateRoomList.dateRoomId = dateString
//                        dateRoomList.list.append(dateRoom)
//                        realm.add(dateRoomList)
////                        self.list = realm.objects(DateRoomList.self).first?.list
////                        self.list = realm.objects(DateRoomList.self).last?.list
////                        print("listInから: ", list ?? "")
//                    } else {
//                        print("からじゃない")
//                        self.list.append(dateRoom)
//                        print("listInからじゃない: ", list ?? "")
//                    }
                    
            }
//            setMemoryTableView.reloadData()
        } else { // 二回目以降の処理
            
//            let itemList = DateRoomList()
            let dateRoomListResult = realm.objects(DateRoomList.self)
//                .filter("dateRoomId == '\(dateString)'")
            let dateRoomListResultArray = Array(dateRoomListResult)
//            print("dateRoomListResult: ", dateRoomListResult)
//            print("dateRoomListResultArray: ", dateRoomListResultArray)
            
            for allIndex in dateRoomListResult.indices {
//                print("allIndex: ", allIndex)
                let indicedItemListResult = filteredDateRoomResult[allIndex].order
//                print("indicedItemListResult: ", indicedItemListResult)
                cell.priorityLabel.text = String(indicedItemListResult)
//                cell.priorityLabel.text = String(allIndex.row)
//                cell.priorityLabel.text = String(allIndex.row)

            }
            
            
//            try! realm.write {
//            if self.list == nil {
//                let itemList = DateRoomList()
//                itemList.list.append(dateRoom)
//                realm.add(itemList)
//                self.list = realm.objects(DateRoomList.self).first?.list
//            } else {
//                print("else")
//            }
//            }

                
//                if self.list == nil {
//                    let itemList = DateRoomList()
//                    itemList.list.append(dateRoom)
////                    realm.add(itemList)
//                    self.list = realm.objects(DateRoomList.self).first?.list
//                } else {
//                    self.list.append(dateRoom)
//                }

                        
//            for IndexPath in itemListResult.indices {
////            これで見えてる全セルのindexPathとれる？
//                setMemoryTableView.cellForRow(at: IndexPath)
////                setMemoryTableView.cellForRow(at: IndexPath) = IndexPath.row
////                cell.priorityLabel.text = String(itemListResult[IndexPath.row].)
//            }
            
//            if let indexPaths = tableView.indexPathsForVisibleRows {
//            for IndexPath in indexPaths {
////            これで見えてる全セルのindexPathとれる？
//                setMemoryTableView.cellForRow(at: IndexPath)
//                setMemoryTableView.reloadData()
////                setMemoryTableView.cellForRow(at: IndexPath) = IndexPath.row
////                cell.priorityLabel.text = String(itemListResult[IndexPath.row].)
//            }
//            }
            
//            これやるならかきこみだからトランザクションない
//            do {
//                let filteredDateRoomResultArray = Array(filteredDateRoomResult)
//                filteredDateRoomResultArray[indexPath.row].order = itemListResult[indexPath.row].li
////                    .sorted(byKeyPath: "order")
//            }
            
//            filteredDateRoomResultArray[indexPath.row].order = itemListResult[indexPath.row]

//            cell.priorityLabel.text = "\(itemListResultArray[indexPath.row])"
//            cell.priorityLabel.text = "\(list[indexPath.row])"
//            cell.priorityLabel.text = String(itemListResult.so)
//            cell.priorityLabel.text = String(itemListResult[indexPath.row].list)
//                cell.priorityLabel.text = String(filteredDateRoomResult[indexPath.row].order)

            
//            let itemList = DateRoomList()
//            let itemListResult = realm.objects(DateRoomList.self)
//            print("itemListResult: ", itemListResult)
            
//            なぜかエラる
//            print("itemListResult[allIndex].list: ", itemListResult[indexPath.row].list)
            
//            setMemoryTableView.indexPath(for: <#T##UITableViewCell#>)
            
//            for allIndex in itemListResult.indices {
//                setMemoryTableView.cellForRow(at: itemListResult[allIndex].list)
//                setMemoryTableView.indexPath(for: )
//            }
            
//            setMemoryTableView.cellForRow(at: itemListResult[indexPath.row])
//            setMemoryTableView
            
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
    
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        print("canMoveRowAt")
//        return true
//    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
//        setMemoryTableView.delegate = self
        print("didEndEditingRowAt")
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
//            dateRoomList = realm.objects(DateRoom.self)
//            var dateRoomListArray = Array(dateRoomList)

//            let eventListArray = Array(eventList)
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//            let filteredEventListArray = eventListArray.filter {
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//            }

            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
            print("filteredDateRoomResultInM: ", filteredDateRoomResult)
            
//            objects = realm.objects(DateRoomList.self).last?.list
            
//            closure?
//            let closure = { (indexPathParameter: IndexPath) -> IndexPath in
//                return indexPathParameter
//            }
            
//            let indexPath: IndexPath
            
//            init(indexPath)
            
//            setMemoryTableView.cellForRow(at: indexPath)
            

//            let tappedFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[sourceIndexPath.row].event)'")
//            print("tappedFilteredDateRoomResult: ", tappedFilteredDateRoomResult)
//
//            let exiledFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[destinationIndexPath.row].event)'")
//            print("exiledFilteredDateRoomResult: ", exiledFilteredDateRoomResult)
            
//            var filteredDateRoomResultArray = Array(filteredDateRoomResult)
//            print("filteredDateRoomResultArrayInM: ", filteredDateRoomResultArrayInM)

            try! realm.write({
                
//                must
                let listItem = list[sourceIndexPath.row]
                list.remove(at: sourceIndexPath.row)
                list.insert(listItem, at: destinationIndexPath.row)
                
//                filteredDateRoomResultArray
                                
//                let moveData = tableView.cellForRow(at: sourceIndexPath).priorityLabel.text
//                let moveData = tableView.cellForRow(at: sourceIndexPath)
//                let moveDataArray = Array(arrayLiteral: moveData)
                
//                let sourceObject = objects[sourceIndexPath.row]
//                objects.remove(at: sourceIndexPath.row)
//                objects.insert(sourceObject, at: destinationIndexPath.row)
                
                
//                書き込み
                
//                違いなし
//                print("filteredDateRoomResult[sourceIndexPath.row]: ", filteredDateRoomResult[sourceIndexPath.row])
//                print("filteredDateRoomResultArray[sourceIndexPath.row]: ", filteredDateRoomResultArray[sourceIndexPath.row])
//                print("filteredDateRoomResult[destinationIndexPath.row]: ", filteredDateRoomResult[destinationIndexPath.row])
//                print("filteredDateRoomResultArray[destinationIndexPath.row]: ", filteredDateRoomResultArray[destinationIndexPath.row])

//                filteredDateRoomResultArray.remove(at: sourceIndexPath.row)
//                filteredDateRoomResultArray.remove(at: tappedFilteredDateRoomResult.last?.order ?? 0)
//                print("filteredDateRoomResultArrayAfterRemove: ", filteredDateRoomResultArray)

//                setMemoryTableView.reloadData()

//                filteredDateRoomResult[destinationIndexPath.row].order = destinationIndexPath.row
//                tappedFilteredDateRoomResult.last?.order = destinationIndexPath.row
//                print("filteredDateRoomResultArrayAfterTapped: ", filteredDateRoomResultArray)

//                filteredDateRoomResultArray.insert(filteredDateRoomResultArray[sourceIndexPath.row], at: destinationIndexPath.row)
//                filteredDateRoomResultArray.insert(filteredDateRoomResultArray[sourceIndexPath.row], at: destinationIndexPath.row)
//                filteredDateRoomResultArray.insert(contentsOf: tappedFilteredDateRoomResult, at: destinationIndexPath.row)
//                print("filteredDateRoomResultArrayAfterInsert: ", filteredDateRoomResultArray)

//                setMemoryTableView.reloadData()

//                filteredDateRoomResult[sourceIndexPath.row].order = sourceIndexPath.row
//                exiledFilteredDateRoomResult.last?.order = sourceIndexPath.row
//                print("filteredDateRoomResultArrayAfterExiled: ", filteredDateRoomResultArray)
                
//                filteredDateRoomResultArray[sourceIndexPath.row].order = sourceIndexPath.row
//                filteredDateRoomResultArray[destinationIndexPath.row].order = destinationIndexPath.row
                
                
                
                
//                例のサイト
//                let sourceObject = filteredDateRoomResultArray[sourceIndexPath.row]
//                let destinationObject = filteredDateRoomResultArray[destinationIndexPath.row]
//
//
//                if sourceIndexPath.row < destinationIndexPath.row {
//                            // 上から下に移動した場合、間の項目を上にシフト
//                            for index in sourceIndexPath.row...destinationIndexPath.row {
////                                let object = filteredDateRoomResultArray[index]
////                                object.order -= 1
//                                var object = filteredDateRoomResultArray[index].order
//                                object -= 1
////                                print("", )
//
//                            }
//                        } else {
//                            // 下から上に移動した場合、間の項目を下にシフト
//                            for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed()
////                                .reverse()
//                            {
////                                let object = filteredDateRoomResultArray[index]
////                                object.order += 1
//                                var object = filteredDateRoomResultArray[index].order
//                                object += 1
//                            }
//                        }
//
//                        // 移動したセルの並びを移動先に更新
//                sourceObject.order = destinationObject.order
//                例のサイト終
                
                
//                                            setMemoryTableView.reloadData()
                //                            setMemoryTableView.
            })
        } catch {
            print("エラーですぞ")
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


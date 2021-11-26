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
    var dateRoomList: Results<DateRoom>!
    var eventString: String?
//    var dateRoomResultProperty: Results<DateRoom>!
    var dateRoomIndexPathRow: DateRoom!
    var tappedFilteredDateRoomResultProperty: Results<DateRoom>!
//    var tableViewOrder = Int()
//    var filteredDateRoomResultArray: Array? = []
    var moveRowToTappedEditButton = Int()
//    static var filteredDateRoomResultArray = [Results<DateRoom>]()
    var objects: List<DateRoom>!
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//            var eventList: Results<Event>!
            eventList = realm.objects(Event.self)
            dateRoomList = realm.objects(DateRoom.self) // 無いとdelegateメソッド内でnilなる
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
                
                if let indexPaths = setMemoryTableView.indexPathsForVisibleRows {
                for indexPath in indexPaths {
                    
                    
    //            これで見えてる全セルのindexPathとれる？
//                    print("indexPaths: ", indexPaths)
//                    print("indexPath: ", indexPath)
                    
//                    moveRow内で正確に配列の並び替え保存できたら保存されてるorder順に表示する。値型だから今はただのコピー
//                    try! realm.write({
//
//                        filteredDateRoomResult[indexPath.row].order = indexPath.row
//
////                        let filteredDateRoomResultArrayStruct = FilteredDateRoomResultArrayStruct()
////                        if filteredDateRoomResultArray == filteredDateRoomResultArray {
////                        for allIndex in filteredDateRoomResultArrayStruct.filteredDateRoomResultArray.indices {
//
////                            allIndex[]
////                            print("allIndex: ", allIndex)
////                            filteredDateRoomResultArray[allIndex].order = indexPath.row
//
////                        }
////                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
////                        filteredDateRoomResult[indexPath.row].order = indexPath.rowfilteredDateRoomResultArray
////                                             ↑↑  >                     ↑↑
////                        }
//                    })
                }
                }
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
    
//    func fetchCurrentIndexInfo(cell: UITableViewCell) {
////        let row = setMemoryTableView.indexPath(for: cell)?.row
////        print("row: ", row ?? "")
//        print("fetchCurrentIndexInfo")
//    }
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("willDisplay")
//    }
        
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

//            選択日と合致するdateRoomIdを持つDateRoomを取得
        let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
//            print("filteredDateRoomResult: ", filteredDateRoomResult)
        
        let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[indexPath.row].event)'")
//        print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)

        if secondFilteredDateRoomResult.isEmpty == true {

                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString

                try! realm.write{
                    realm.add(dateRoom)
                    
                    do {
                        let filteredDateRoomResultArray = Array(filteredDateRoomResult)
                        filteredDateRoomResultArray[indexPath.row].order = indexPath.row
                    }
            }
        } else { // 二回目以降の処理
                cell.priorityLabel.text = String(filteredDateRoomResult[indexPath.row].order)
            
//            let closure = { (indexPathParameter: IndexPath) -> Int in
//                return indexPathParameter.row
//            }
            
//            closure(indexPath)
            
            }
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do {
                let realm = try Realm()

                try realm.write({
                    realm.delete(eventList[indexPath.row])
                    realm.delete(dateRoomList)

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
        print("didEndEditingRowAt")
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
//            dateRoomList = realm.objects(DateRoom.self)
//            var dateRoomListArray = Array(dateRoomList)

            let eventListArray = Array(eventList)
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let filteredEventListArray = eventListArray.filter {
                $0.day.contains("\(dateString)")
                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
            }

            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
            print("filteredDateRoomResultInM: ", filteredDateRoomResult)
            
            objects = realm.objects(DateRoomList.self).first?.list
            
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
            
            var filteredDateRoomResultArray = Array(filteredDateRoomResult)
//            print("filteredDateRoomResultArrayInM: ", filteredDateRoomResultArrayInM)
            
//            let dateRoom = DateRoom()
//            print("dateRoom.order: ", dateRoom.order)

            try! realm.write({
                                
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

                filteredDateRoomResultArray.remove(at: sourceIndexPath.row)
//                filteredDateRoomResultArray.remove(at: tappedFilteredDateRoomResult.last?.order ?? 0)
                print("filteredDateRoomResultArrayAfterRemove: ", filteredDateRoomResultArray)

//                setMemoryTableView.reloadData()

                filteredDateRoomResult[destinationIndexPath.row].order = destinationIndexPath.row
//                tappedFilteredDateRoomResult.last?.order = destinationIndexPath.row
                print("filteredDateRoomResultArrayAfterTapped: ", filteredDateRoomResultArray)

                filteredDateRoomResultArray.insert(filteredDateRoomResultArray[sourceIndexPath.row], at: destinationIndexPath.row)
//                filteredDateRoomResultArray.insert(filteredDateRoomResultArray[sourceIndexPath.row], at: destinationIndexPath.row)
//                filteredDateRoomResultArray.insert(contentsOf: tappedFilteredDateRoomResult, at: destinationIndexPath.row)
                print("filteredDateRoomResultArrayAfterInsert: ", filteredDateRoomResultArray)

//                setMemoryTableView.reloadData()

                filteredDateRoomResult[sourceIndexPath.row].order = sourceIndexPath.row
//                exiledFilteredDateRoomResult.last?.order = sourceIndexPath.row
                print("filteredDateRoomResultArrayAfterExiled: ", filteredDateRoomResultArray)
                
                
                
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


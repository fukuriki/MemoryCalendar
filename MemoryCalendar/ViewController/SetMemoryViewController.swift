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
    var tappedFilteredDateRoom: Results<DateRoom>!
    var tableViewOrder = Int()
    
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
//                eventList = realm.objects(Event.self)
//    //            dateRoomList = realm.objects(DateRoom.self)
//
//                let eventListArray = Array(eventList)
                let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//                let filteredEventListArray = eventListArray.filter {
//                    $0.day.contains("\(dateString)")
//                    || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//                }
                
    //            print("filteredEventListArray: ", filteredEventListArray)
    //            print("eventListArray: ", eventListArray)

    //            var dateRoomListArray = Array(dateRoomList)
                
    //            filteredEventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    //            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

    //            dateRoomListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                
    //            let dateRoomResult = realm.objects(DateRoom.self)
    //            print("dateRoomResult: ", dateRoomResult)
                
    //            let dateRoom = DateRoom()
                
                
    //            選択日と合致するdateRoomIdを持つDateRoomを取得
    //            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
    //            print("filteredDateRoomResult: ", filteredDateRoomResult)
    //            let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(eventString ?? "")'")
    //            print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
                
    //            dateRoomList = secondFilteredDateRoomResult
    //            let dateRoomListArray = Array(dateRoomList)
    //            print("dateRoomListArray: ", dateRoomListArray)
    //            dateRoomListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                
                
                
    //            for allIndex in dateRoomResult.indices {
    //                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateRoomResult[allIndex].dateRoomId)'")
    //                let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(dateRoomResult[allIndex].event)'")
    //                print("filteredDateRoomResult: ", filteredDateRoomResult)
    //                print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
    //                print("allIndex: ", allIndex)
                
                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
                print("filteredDateRoomResult: ", filteredDateRoomResult)
    //            var filteredDateRoomResultArray = Array(filteredDateRoomResult)
    //            print("filteredDateRoomResultArray.count moveRowAt: ", filteredDateRoomResultArray.count)
    //
    //            filteredDateRoomResultArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                
                let tappedFilteredDateRoomResult = tappedFilteredDateRoom
                print("tappedFilteredDateRoomResult: ", tappedFilteredDateRoomResult ?? [
                ]
)
    //            print("tappedFilteredDateRoomResult.count moveRowAt: ", tappedFilteredDateRoomResult.count)
                
                let filteredDateRoomResultArray = Array(filteredDateRoomResult)
                print("filteredDateRoomResultArray: ", filteredDateRoomResultArray)
                
    //            filteredDateRoomResultArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    //            filteredEventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

    //            print("filteredDateRoomResultArray[sourceIndexPath.row]: ", filteredDateRoomResultArray[sourceIndexPath.row])
    //            print("filteredEventListArray[sourceIndexPath.row]: ", filteredEventListArray[sourceIndexPath.row])
//                print("filteredDateRoomResultArray[destinationIndexPath.row]: ", filteredDateRoomResultArray[destinationIndexPath.row])
//                print("filteredEventListArray[destinationIndexPath.row]: ", filteredEventListArray[destinationIndexPath.row])

    //                    let equalQuery = secondFilteredDateRoomResult.filter("event == '\(filteredEventListArray[sourceIndexPath.row].event)'")
    //                        .first
                
    //                if equalQuery?.dateRoomId == dateString {
                
                print("tableViewOrder: ", tableViewOrder)

                            try! realm.write({
                                
    //                            filteredDateRoomResultArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    //                            filteredEventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                                
    //                            let indexPath = IndexPath()

    //                            tappedFilteredDateRoomResult?.order = destinationIndexPath.row
    //                            print("tappedFilteredDateRoomResult?.order:", tappedFilteredDateRoomResult?.order ?? 0)
                                
//                                print("dateRoomIndexPathRow.order: ", dateRoomIndexPathRow.order)
                                
//                                dateRoomIndexPathRow.order = destinationIndexPath.row
//                                filteredDateRoomResult[sourceIndexPath.row].order = destinationIndexPath.row
                                
                                filteredDateRoomResultArray[tableViewOrder].order = tableViewOrder
//                                filteredDateRoomResult[destinationIndexPath.row].order = destinationIndexPath.row
//                                filteredDateRoomResult[IndexPath].order = setMemoryTableView.
                                
    //                            filteredDateRoomResult[sourceIndexPath.row].order = destinationIndexPath.row
    //                            filteredDateRoomResultArray[destinationIndexPath.row].order = filteredDateRoomResult[destinationIndexPath.row].order
    //                            filteredDateRoomResult[sourceIndexPath.row].order = filteredDateRoomResult[destinationIndexPath.row].order
    //                            filteredDateRoomResult[sourceIndexPath.row].order = filteredEventListArray[destinationIndexPath.row].hash
    //                            print("filteredEventListArray[destinationIndexPath.row]: ", filteredEventListArray[destinationIndexPath.row])
    //                            filteredEventListArray[sourceIndexPath.row].order = destinationIndexPath.row
                                

    //                            tappedFilteredDateRoomResult[indexPath.row].order = destinationIndexPath.row
    //                            tappedFilteredDateRoomResult[destinationIndexPath.row].order = destinationIndexPath.row
    //                            tappedFilteredDateRoomResult[sourceIndexPath.row].order = destinationIndexPath.row

    //                            print("tappedFilteredDateRoomResult[destinationIndexPath.row].order: ", tappedFilteredDateRoomResult[destinationIndexPath.row].order)
    //                            print("tappedFilteredDateRoomResult[sourceIndexPath.row].order: ", tappedFilteredDateRoomResult[sourceIndexPath.row].order)


    //                            dateRoom.order = destinationIndexPath.row
    //                            print("dateRoom.order: ", dateRoom.order)
    //                            equalQuery?.order = destinationIndexPath.row
    //                            print("equalQuery.order: ", equalQuery?.order ?? 0)
                                
    //                            filteredDateRoomResultArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    //                            filteredEventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                                
    //                            setMemoryTableView.reloadData()
    //                            setMemoryTableView.

                            })
    //                } //if
    //            } //indices

            } catch {
                print("エラーですぞ")
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
//            print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
        
//   [DateRoom]
        dateRoomIndexPathRow = filteredDateRoomResult[indexPath.row]
//        dateRoomResultProperty = secondFilteredDateRoomResult

            if secondFilteredDateRoomResult.isEmpty == true {

                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString

                try! realm.write{
                    realm.add(dateRoom)
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)

            let eventListArray = Array(eventList)
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            var filteredEventListArray = eventListArray.filter {
                $0.day.contains("\(dateString)")
                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
            }
                        
            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
            let tappedFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(filteredEventListArray[sourceIndexPath.row].event)'")
            var filteredDateRoomResultArray = Array(filteredDateRoomResult)
            tappedFilteredDateRoom = tappedFilteredDateRoomResult
            tableViewOrder = destinationIndexPath.row
            
            filteredEventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            filteredDateRoomResultArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)

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


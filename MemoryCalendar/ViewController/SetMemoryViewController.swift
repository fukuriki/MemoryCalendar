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
    var isFirst = Bool()
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(tappedEditBarButton))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        
//        let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//        let eventListArray = Array(eventList)
//
//        let filteredEventListArray = eventListArray.filter {
//            $0.day.contains("\(dateString)")
//            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//        }
//
//        do {
//            let realm = try Realm()
//            let dateRoom = DateRoom()
//
//            let dateRoomResult = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[indexPath.row].event)'")
//
//            if dateRoomResult.isEmpty == true {
//                dateRoom.event = filteredEventListArray[indexPath.row].event
//                dateRoom.dateRoomId = dateString
//
//                try realm.write{
//                    realm.add(dateRoom)
//                }
//            }
//
//        } catch {
//
//            }
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
//            print("dateStringInN: ", dateString)
            
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
        
        print("filteredEventListArray: ", filteredEventListArray)


//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
        eventString = filteredEventListArray[indexPath.row].event
        cell.eventTextView.text = eventString
//        print("eventString: ", eventString ?? "")
        
        do {
            let realm = try! Realm()
            let dateRoom = DateRoom()
            
//            let dateRoomResult = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[indexPath.row].event)'")
//                .last
//            let keys = dateRoomResult.map
            
//            let dateRoomResultEvent = dateRoomResult?.event
//            let secondFilteredEventListArray = realm.objects(Event.self).filter("dateRoomId CONTAINS '\(dateRoomResult?.dateRoomId ?? "")'")

            
//            print("dateRoomResult: ", dateRoomResult ?? [])

//            print("dateRoomResult?.dateRoomId: ", dateRoomResult?.dateRoomId ?? "")
//            print("dateString: ", dateString)
            
//            print("dateRoomResultEvent: ", dateRoomResultEvent ?? "")
//            print("filteredEventListArray[indexPath.row].event: ", filteredEventListArray[indexPath.row].event)

//            let filteredDateRoomResult = dateRoomResult.filter("dateRoomId CONTAINS '\(dateString)'")
//                .last
            
//                            if !isFirst { return }
            
            

//            選択日と合致するdateRoomIdを持つDateRoomを取得
            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")
            print("filteredDateRoomResult: ", filteredDateRoomResult)


//            for dividedDateRoomResult in filteredDateRoomResult.indices
//            {
//                let dateRoom = DateRoom()

//                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateRoomResult[dividedDateRoomResult].dateRoomId)'")
//                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateString)'")

//                filteredDateRoomResult（選択日と合致するdateRoomIdを持つDateRoom）のevent名と合致するDateRoomを取得？のつもり
//                しかし、DateRoom全体の一致するevent名取得してる
            
//                let dateRoomResultDiv = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredDateRoomResult[dividedDateRoomResult].event)'").last
            
//                let dateRoomResultDiv = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[dividedDateRoomResult].event)'")
//                    .last

//                let dateRoomResultDivArray = Array(dateRoomResultDiv)
//                let dateRoomResultInd = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[indexPath.row].event)'")

//                let dateRoomResultEvent = dateRoomResult?.event
//                print("dateRoomResultEvent: ", dateRoomResultEvent ?? "")

//                print("dateRoomResultDiv: ", dateRoomResultDiv )
//                print("dateRoomResultDiv[indexPath.row].dateRoomId: ", dateRoomResultDiv[indexPath.row].dateRoomId)
                
//                print("dividedDateRoomResult: ", dividedDateRoomResult)


//                if dateRoomResultDivArray[indexPath.row].dateRoomId != dateString
//                if dateRoomResultDiv[dividedDateRoomResult].dateRoomId != dateString
//                    if dateRoomResultDiv[indexPath.row].dateRoomId != dateString
//                if dateRoomResultDiv[indexPath.row]["dateRoomId"] as! String != dateString
//                if dateRoomResultDiv?.dateRoomId != dateString
//                if dateRoomResultDiv.contains("\(dateString)")
//                if dateRoomResultDiv?.dateRoomId != dateString
//                    && dateRoomResultDiv. != filteredEventListArray[indexPath.row].event
//                && dateRoomResultEvent != filteredEventListArray[indexPath.row].event
//                        && dateRoomResultEvent != secondFilteredEventListArray
//            {

//                switch
//                if !isFirst { return }
//            if dateRoomResult.isEmpty == true {

                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString

                try! realm.write{
//                    dateRoom.event = filteredEventListArray[indexPath.row].event
//                    dateRoom.dateRoomId = dateString
                    realm.add(dateRoom)
                }
//            }
//            } // indices
//        }

        } catch {

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
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
//        do {
//            let realm = try Realm()
//            eventList = realm.objects(Event.self)
//
//            let eventListArray = Array(eventList)
//            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//            let filteredEventListArray = eventListArray.filter {
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//            }
//
////            print("filteredEventListArray: ", filteredEventListArray)
//            eventString = filteredEventListArray[indexPath.row].event
//            print("eventString: ", eventString ?? "")
//
//        } catch {
//            print("エラーですぞ")
//        }

        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        do {
            let realm = try Realm()
            eventList = realm.objects(Event.self)
            dateRoomList = realm.objects(DateRoom.self)

            var eventListArray = Array(eventList)
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let filteredEventListArray = eventListArray.filter {
                $0.day.contains("\(dateString)")
                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
            }
            
            print("filteredEventListArray: ", filteredEventListArray)
            print("eventListArray: ", eventListArray)

//            var dateRoomListArray = Array(dateRoomList)
            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//            dateRoomListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            
            let dateRoomResult = realm.objects(DateRoom.self)
//            print("dateRoomResult: ", dateRoomResult)
            
            for allIndex in dateRoomResult.indices {
                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateRoomResult[allIndex].dateRoomId)'")
                let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(dateRoomResult[allIndex].event)'")
//                print("filteredDateRoomResult: ", filteredDateRoomResult)
//                print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
//                print("allIndex: ", allIndex)
  
                    let equalQuery = secondFilteredDateRoomResult.filter("event == '\(filteredEventListArray[sourceIndexPath.row].event)'")
                        .first
                
                if equalQuery?.dateRoomId == dateString {

                        try! realm.write({

                            equalQuery?.order = destinationIndexPath.row
                            print("equalQuery: ", equalQuery ?? [])
                        })
                }
            }

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
//                                    print(Realm.Configuration.defaultConfiguration.fileURL!)
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


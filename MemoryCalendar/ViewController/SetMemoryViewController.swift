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
//    let realm = Realm()

//    lazy var realm = Realm()
//    let realm = try! Realm(configuration: )


//    private var event = [Event]()
    var date = Date()
    var editBarButtonItem: UIBarButtonItem!
    var eventList: Results<Event>!
//    var eventList: Results<Event>!
//    var eventList: Result<Event>!

    var dateRoomList: Results<DateRoom>!
//    var sortedData: Results<ItemList>!
//    var sortedData: 
//    var listedObject: List<Event>!

    
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
//        eventList = realm.objects(Event.self).sorted(by: <#T##Sequence#>)
//        print("eventList: ", self.eventList)
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        realmMigration()
    }
    
//    override class func awakeFromNib() {
//        super.awakeFromNib()
//        realmMigration()
//    }
    
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
    
//    func realmMigration() {
//
//        let migSchemaVersion: UInt64 = 1
//
//        let config = Realm.Configuration(
//            schemaVersion: migSchemaVersion,
//            migrationBlock: { migration, oldSchemaVersion in
//                if (oldSchemaVersion < migSchemaVersion) {
//
//                }
//            })
//        Realm.Configuration.defaultConfiguration = config
//    }
    
    
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
//        catch {
//
//        }
        
//        try! realm.write({
//            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//            let eventListArray = Array(eventList)
//
//            let filteredEventListArray = eventListArray.filter {
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//            }
//
//        return filteredEventListArray.count
//        })
//            let realm = try Realm()
//            eventList = realm.objects(Event.self)
//        var eventList = Results<Event>()

            

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
//        print("dateStringInC: ", dateString)
//        var eventList: Results<Event>!
        let eventListArray = Array(eventList)

        let filteredEventListArray = eventListArray.filter {
            $0.day.contains("\(dateString)")
            || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
        }

//            cell.reviewDayLabel.text = eventListArray[indexPath.row].keys
        cell.eventTextView.text = filteredEventListArray[indexPath.row].event
        
        do {
            let realm = try Realm()
            let dateRoom = DateRoom()
//            let eventResult = realm.objects(Event.self)
//            let dateRoomResult = realm.objects(DateRoom.self)
            let dateRoomResult = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[indexPath.row].event)'")
//            let stringDateRoomResult = String("\(dateRoomResult)")
//            let dateRoomResult = realm.objects(DateRoom.self).filter("")
//            print("dateRoomResult: ", dateRoomResult)

            
            if dateRoomResult.isEmpty == true {
                dateRoom.event = filteredEventListArray[indexPath.row].event
                dateRoom.dateRoomId = dateString
//              print("dateStringInCInIf: ", dateString)


                try realm.write{
                    realm.add(dateRoom)
                }
            }
           
        } catch {

            }
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        print("dateRoomList: ", dateRoomList.description)
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do {
                let realm = try Realm()
//                let dateRoomListP = dateRoomList
//                let ta = realm.objects(Event.self).first
                try realm.write({
//                    var eventList: Results<Event>!
                    realm.delete(eventList[indexPath.row])
                    realm.delete(dateRoomList)

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
//            var eventList: Results<Event>!
            eventList = realm.objects(Event.self)
            dateRoomList = realm.objects(DateRoom.self)
//            let dateRoomResult = realm.objects(DateRoom.self).filter("event CONTAINS '\(filteredEventListArray[indexPath.row].event)'")
//            listedObject = realm.objects(DateWrapper.self).first?.list
//            print("listedObject: ", listedObject)
            var eventListArray = Array(eventList)
//            print("eventListArray: ", eventListArray)
            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
            let filteredEventListArray = eventListArray.filter {
                $0.day.contains("\(dateString)")
                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
            }
            print("filteredEventListArray: ", filteredEventListArray)

            var dateRoomListArray = Array(dateRoomList)
            eventListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            dateRoomListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            
//            let nextSchemaVersion: UInt64 = 2
//
//            var config = Realm.Configuration(
//                schemaVersion: 2,
//                migrationBlock: { migration, oldSchemaVersion in
//                    if (oldSchemaVersion < 2) {
//
//                    }
//                })
//
//                    Realm.Configuration.defaultConfiguration = config
//            config.deleteRealmIfMigrationNeeded = true

//            let event = Event()
//            let dateRoom = DateRoom()
            
            
//            print("dateRoomListArray: ", dateRoomListArray)
            
//            この二ついる？
//            let dateString = SettingDate.stringFromDate(date: date, format: "y-MM-dd")
//
//            let filteredEventListArray = eventListArray.filter {
//                $0.day.contains("\(dateString)")
//                || $0.reviewDay1.contains("\(dateString)") || $0.reviewDay3.contains("\(dateString)") || $0.reviewDay7.contains("\(dateString)") || $0.reviewDay30.contains("\(dateString)")
//            }
            
            let dateRoomResult = realm.objects(DateRoom.self)
            print("dateRoomResult: ", dateRoomResult)
            
            for allIndex in dateRoomResult.indices {
                let filteredDateRoomResult = realm.objects(DateRoom.self).filter("dateRoomId == '\(dateRoomResult[allIndex].dateRoomId)'")
                let secondFilteredDateRoomResult = filteredDateRoomResult.filter("event == '\(dateRoomResult[allIndex].event)'")
//                    .first
                print("filteredDateRoomResult: ", filteredDateRoomResult)
                print("secondFilteredDateRoomResult: ", secondFilteredDateRoomResult)
                print("allIndex: ", allIndex)
                
//                if secondFilteredDateRoomResult == filteredEventListArray {
//                }
                
            
                for eventAllIndex in filteredEventListArray.indices {
                    let equalQuery = secondFilteredDateRoomResult.filter("event == '\(filteredEventListArray[eventAllIndex].event)'")
                        .first
//                let equalQuery = filteredEventListArray.filter("event == '\(secondFilteredDateRoomResult[allIndex].event)'")
//                    print("equalQuery: ", equalQuery)
//                    var equalQueryArray = Array(arrayLiteral: equalQuery)
                    
//                    let holdingCell = filteredEventListArray[sourceIndexPath.row]
//                    holdingCell.
                    
                        try! realm.write({
                            
//                            let equalQueryArraySource = equalQueryArray[sourceIndexPath.row]
//                            equalQueryArray.remove(at: sourceIndexPath.row)
//                    equalQueryArray.insert(contentsOf: equalQueryArray, at: destinationIndexPath.row)
                            
                            equalQuery?.order = destinationIndexPath.row
                            print("equalQuery: ", equalQuery ?? [])
                        })
                }
            }
            
//            let dateRoomResult = realm.objects(DateRoom.self).filter("event == '\(dateRoomListArray.)'").first
//            let filteredDateRoomResult = realm.objects(DateRoom.self).filter("event == '\(dateRoomResult[].event)'")
            //            ↑おごくやーつ
//            print("filteredEventListArray: ", filteredEventListArray)

            
//            cell.eventTextView.text = filteredEventListArray[indexPath.row].event  見本
//            let cellIncludingOrder = filteredEventListArray[indexPath.row].order
//            var eventOrder = event.order
//            eventOrder = cellIncludingOrder
            
//            let filteredOrder = realm.objects(Event.self).filter()
            
//            var filteredOrder = realm.objects(Event.self).value(forKey: "order")

            
//            var eventOrder = event.order
//            eventOrder = destinationIndexPath.row
            
//            event.order = destinationIndexPath.row
//            print("event.order: ", event.order)
//
//            try! realm.write({
//                realm.add(dateRoom)
                
//                let results = dateRoomList
//                results[].order = destinationIndexPath.row
                
//                dateRoomListArray
//                dateRoomResult?.order = destinationIndexPath.row
//                ↑動くやーつ
                
//                dateRoom.order = destinationIndexPath.row
//                print("dateRoom.order: ", dateRoom.order)
//                print("dateRoom.event: ", dateRoom.event)
                
//                eventOrder = destinationIndexPath.row
//                event.order = destinationIndexPath.row
//                print("event.order: ", event.order)

//                filteredOrder.order = destinationIndexPath.row
//                realm.add(filteredOrder as! Object)

                
////                realm.add(event, update: .modified)
//                setMemoryTableView.reloadData()
//            })

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


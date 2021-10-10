////
////  ContainerViewController.swift
////  MemoryCalendar
////
////  Created by 福井孝政 on 2021/10/02.
////
//
//import UIKit
//import RealmSwift
//import FSCalendar
//
//class ContainerViewController: SetMemoryViewController {
//
////    let select
//
////    let setMemoryViewController = SetMemoryViewController()
//
////    private let cellId = "cellId"
//
//    @IBOutlet weak var sampleTableView: UITableView!
//
//
//    @IBAction func tappedNewTaskButton(_ sender: Any) {
//
//        popUpInterface()
//    }
//
//    @IBOutlet weak var newTaskButton: UIButton!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        newTaskButton.layer.cornerRadius = 35
//
////        setMemoryTableView.delegate = self
////        setMemoryTableView.dataSource = self
//
////        sampleTableView.delegate = self
////        sampleTableView.dataSource = self
//
//        sampleTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
//
//
////        NotificationCenter.default.addObserver(self, selector: #selector(giveDate), name: .notifyName, object: nil)
//
//    }
//
////    func getDelegate() ->
//
//    private func popUpInterface() {
//
//        var alertTextField: UITextField?
//
//        let alert = UIAlertController(
//                    title: "復習すべきこと",
//                    message: "Enter your task",
//                    preferredStyle: UIAlertController.Style.alert)
//                alert.addTextField(
//                    configurationHandler: {(textField: UITextField!) in
//                        alertTextField = textField
////                        textField.text = self.label1.text
//                    })
//        alert.addAction(
//                    UIAlertAction(
//                        title: "Cancel",
//                        style: UIAlertAction.Style.cancel,
//                        handler: nil))
//                alert.addAction(
//                    UIAlertAction(
//                        title: "OK",
//                        style: UIAlertAction.Style.default) { _ in
////                        if let text = alertTextField?.text {
////                            self.label1.text = text
////                        }
//                            print("tappedOKButton")
//
////                            self.giveDate()
//
//
////                            NotificationCenter.default.post(name: .notifyName, object: nil)
//
//
//
////                            if let date = notification.userInfo? ["date"] as? Date {
//
//                            let day = self.date
////                            let day = Date()
//                                let reviewDay1 = Calendar.current.date(byAdding: .day, value: 1, to: day)
//                                let reviewDay3 = Calendar.current.date(byAdding: .day, value: 3, to: day)
//                                let reviewDay7 = Calendar.current.date(byAdding: .day, value: 7, to: day)
//                                let reviewDay30 = Calendar.current.date(byAdding: .day, value: 30, to: day)
//
//                                print(day)
//                                print(reviewDay1 ?? "")
//                                print(reviewDay3 ?? "")
//                                print(reviewDay7 ?? "")
//                                print(reviewDay30 ?? "")
////                            }
//
////                        , userInfo: ["date": Any])
//
////                            let date = date
////                            print("date: ", date)
//
////                            self.giveDate(date: <#Date#>)
//
////                            createEvent {
////                                <#code#>
////                            }
//
////                            let calPosition = Calendar.current
//
////                            let dayx =
//
////                            let viewController = ViewController()
////                            let stringSelectedDay = viewController.stringSelectedDay
////                            print("stringSelectedDayInContainer: ", stringSelectedDay)
//
////                            let viewController = ViewController()
////                            let stringSelectedDay = ViewController().stringSelectedDay
////                            print("stringSelectedDayInContainer: ", stringSelectedDay)
//
////                            var day: Date
////                            let viewController = ViewController()
////                            let day = viewController.date
//
////                            let day = Date()
////                            let reviewDay1 = Calendar.current.date(byAdding: .day, value: 1, to: day)
////                            let reviewDay3 = Calendar.current.date(byAdding: .day, value: 3, to: day)
////                            let reviewDay7 = Calendar.current.date(byAdding: .day, value: 7, to: day)
////                            let reviewDay30 = Calendar.current.date(byAdding: .day, value: 30, to: day)
////
////                            print(day)
////                            print(reviewDay1 ?? "")
////                            print(reviewDay3 ?? "")
////                            print(reviewDay7 ?? "")
////                            print(reviewDay30 ?? "")
//                    }
//                )
//                self.present(alert, animated: true, completion: nil)
//    }
//
////    @objc private func giveDate() {
////        let date = NotificationCenter
////        print("date: ", date)
////    }
//
////    func createEvent(success: @escaping () -> Void) {
////        do {
////            let realm = try Realm()
////            let eventModel = Event()
////            eventModel.date = ""
////            eventModel.event = ""
////
//////            eventModel.memo = memoTextView.text
//////            eventModel.date = stringFromDate(date: date as Date, format: "yyyy.MM.dd")
////
////            try realm.write {
////                realm.add(eventModel)
////                success()
////            }
////        } catch {
////            print("create todo error.")
////        }
////    }
//}
//
////extension Notification.Name {
////    static let notifyName = Notification.Name("notifyName")
////}
//
////extension ContainerViewController: FSCalendarDelegate, FSCalendarDataSource {
////
//////    let
////}
//
////extension ContainerViewController: UITableViewDelegate, UITableViewDataSource {
////
////}
//
////extension ContainerViewController: UITableViewDelegate, UITableViewDataSource {
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return 0
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = sampleTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
////        return cell
////    }
////
////
////}

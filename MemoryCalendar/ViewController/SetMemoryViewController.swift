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
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
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
        return 40
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
//        cell.プロパティ
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setMemoryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("trailingSwipeActionsConfigurationForRowAt")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}




class ContainerViewController: UIViewController {
    
    var dateInContainer = Date()
//    var textFieldText1: String? = ""
//    var textFieldText1 = ""


    
    @IBAction func tappedNewTaskButton(_ sender: Any) {
        
        popUpInterface()
    }
    
    @IBOutlet weak var newTaskButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newTaskButton.layer.cornerRadius = 35
    }
    
//    func searchBySearchBarText(textF: UITextField) {
//                   switch textF.tag {
//                   case 1: textFieldText1 = textF.text!
//                   default: break
//                   }
//                   okAction.enabled =  textFieldText1.characters.count > 0 && textFieldText2.characters.count > 0 ? true : false
//               if let alertTextField = textFieldText1 {
//                   okAction.isEnabled = false
//               }
//    }

    
    private func popUpInterface() {
        
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
                    title: "復習すべきこと",
                    message: "Enter your task",
                    preferredStyle: UIAlertController.Style.alert)
        
                alert.addTextField(
                    configurationHandler: {(textField: UITextField!) in
                        alertTextField = textField
//                        alertTextField?.delegate = self
                        
//                        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//                        //        print("textField.text: ", textField.text)
//                            }
                    })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.cancel,
            handler: nil)
        
//        alert.addAction(
//                    UIAlertAction(
//                        title: "Cancel",
//                        style: UIAlertAction.Style.cancel,
//                        handler: nil))
        
        let okAction =  UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
        
//                alert.addAction(
//                    UIAlertAction(
//                        title: "OK",
//                        style: UIAlertAction.Style.default) { _ in
                            
                            
//                            if alertTextField?.text == "" {
//                                UIAlertAction.Style.default = false
//                            }
                            
//                            if alertTextField?.text?.isEmpty {
//
//                            }
                            
//                            guard let text = alertTextField?.text else { return }
                            
//                            alertTextField?.text =
                            
                
//                            let calendar = Calendar(identifier: .japanese)
                            
                            let day = self.dateInContainer.addingTimeInterval(60 * 60 * 24)

//                            let reviewDayLocale = Calendar.current.locale
//                            let reviewDay1 = Calendar.current.dat

                            
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
//                                    succees()
                                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                                    
                                }
                            } catch {
                                    print("create to do err")
                                }
                            }
        
//        func searchBySearchBarText(textF: UITextField) {
//                       switch textF.tag {
//                       case 1: self.textFieldText1 = textF.text!
//                       default: break
//                       }
////                    okAction.enabled =  self.textFieldText1.characters.count > 0 ? true : false
//            if alertTextField?.text == self.textFieldText1 {
//                       okAction.isEnabled = false
//                   }
//                   }
        
//        if alertTextField?.text == "" {
//            okAction.isEnabled = false
//            print("Field空でし")
//        } else if alertTextField?.text?.count ?? 1 >= 1 {
//            okAction.isEnabled = true
//            print("Field\(alertTextField?.text?.count)でし")
//        }
        
//        okAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textField.text: ", textField.text)
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        print("textField.text: ", textField.text)
//    }
    
    
    
    
//    private func storeEventInfo() {
//
//        let event = Event(
//        )
//    }
}

//extension ContainerViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
////        let text = (textField.text! as NSString).chara
////                print("textField.text: ", textField.text)
//    }
//}

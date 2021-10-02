//
//  SetMemoryViewController.swift
//  MemoryCalendar
//
//  Created by 福井孝政 on 2021/09/26.
//

import UIKit
import FSCalendar
import RealmSwift

class SetMemoryViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var setMemoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setMemoryTableView.backgroundColor = .blue
        
        setMemoryTableView.delegate = self
        setMemoryTableView.dataSource = self
        setMemoryTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
//        newTaskButton.addTarget(self, action: #selector(tappedNewTaskButton), for: .touchUpInside)
        
//        let button = UIButton()
//        view.addSubview(button)
        
//        button.heightAnchor.constraint(equalToConstant: 100)
//        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        
//        let screenWidth = self.view.frame.width
//        let screenHeight = self.view.frame.height

        
//        button.frame = CGRect(x: screenWidth/4, y: screenHeight/2, width: screenWidth/2, height: 50)
//        button.frame = CGRect(x: screenWidth/4, y: , width: screenWidth/2, height: 50)

        
//        self.view.addSubview(button)

        
        
//        button.setNeedsLayout()
        
    }
    
//    @objc private func tappedNewTaskButton() {
//
//        print("tappedNewTaskButton")
//    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        let button = UIButton()
//        view.addSubview(button)
//
//        button.heightAnchor.constraint(equalToConstant: 100)
//        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
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
        return 20
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setMemoryTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskTableViewCell
//        cell.プロパティ
        return cell
    }
    
//    ストーリーボード内のセル数と矛盾して落ちる
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
////        tasks.count
//    }
    
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        print("canMoveRowAt")
//        return true
//    }
    
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


//extension SetMemoryViewController: UITableViewDelegate, UITableViewDataSource {
//}

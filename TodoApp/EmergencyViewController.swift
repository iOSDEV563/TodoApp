//
//  EmergencyViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/06/22.
//

import UIKit

class EmergencyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func closeEmergencyViewButton(_ sender: UIButton) {
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegateとdataSourceを設定
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    //tableViewの行数
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    //table viewの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let item = todoItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.messageLabel?.text = item.message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

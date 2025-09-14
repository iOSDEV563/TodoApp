//
//  EmergencyImportantViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/06/17.
//

import UIKit

class EmergencyImportantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - アウトレット
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - プロパティ
    var todoItems: [TodoItem] = []
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - アクション
    @IBAction func closeEmergencyImportantViewButton(_ sender: UIButton) {
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    
   // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyImportantTodoCell", for: indexPath) as? EmergencyImportantTodoCell else {
            fatalError( "EmergencyImportantTodoCellが見つかりません")
        }
        let item = todoItems[indexPath.row]
        cell.titleLabel?.text = item.title
        cell.messageLabel?.text = item.message
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

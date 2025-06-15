//
//  MainViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

struct TodoItem {
    var title: String
    var message: String
    var category: String
}



class ViewController: UIViewController, SubViewControllerDelegate, UITableViewDataSource {
    
    @IBOutlet weak var subViewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emergencyImportantCountLabel: UILabel!
    @IBOutlet weak var importantCountLabel: UILabel!
    @IBOutlet weak var unnecessaryCountLabel: UILabel!
    @IBOutlet weak var emergencyCountLabel: UILabel!
    
    let categories = ["緊急＆重要", "緊急", "不要", "重要"]
    //カテゴリの件数を数える
    func updateCategoryCounts() {
        var counts: [String: Int] = [
            "緊急＆重要": 0,
            "重要": 0,
            "不要": 0,
            "緊急": 0
        ]
        
        for item in todoItems {
            counts[item.category, default: 0] += 1
        }
        
        emergencyImportantCountLabel.text = "\(counts["緊急＆重要"] ?? 0)"
        importantCountLabel.text = "\(counts["重要"] ?? 0)"
        unnecessaryCountLabel.text = "\(counts["不要"] ?? 0)"
        emergencyCountLabel.text = "\(counts["緊急"] ?? 0)"
    }

    
    
    
    //上で定義したTodoItemの要素を配列としてデータを保持
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        //タップされた時の動作
        subViewButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    //+ボタンがタップされた時の処理
    @IBAction func buttonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SubStoryboard", bundle: nil)
        //SubViewControllerの取得（画面遷移のため）
        guard let subVC = storyboard.instantiateViewController(withIdentifier: "SubViewController") as? SubViewController else{print("ViewControllerが見つかりません")
            return }
        //ここでSubViewControllerからデータを受け取る準備
        subVC.delegate = self
        //モーダル画面遷移
        self.present(subVC, animated: true)
    }
    
    
    func didAddTodoItem(title: String, message: String, category: String) {
        let newItem: TodoItem = TodoItem(title: title, message: message, category: category)
        todoItems.append(newItem)
        //データの更新
        tableView.reloadData()
    }
    
    func didAddTodoItem(_ item: TodoItem) {
        todoItems.append(item)
        tableView.reloadData()
        updateCategoryCounts() // ← ここで件数更新
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
            let item = todoItems[indexPath.row]
            cell.titleLabel.text = item.title
            cell.messageLabel.text = item.message
        print("✅ セル生成: \(item.title)")
            return cell
    }
    
    
    
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


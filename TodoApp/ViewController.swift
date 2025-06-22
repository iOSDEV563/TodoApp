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



class ViewController: UIViewController, SubViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var subViewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //各カテゴリの件数ラベル
    @IBOutlet weak var emergencyImportantCountLabel: UILabel!
    @IBOutlet weak var importantCountLabel: UILabel!
    @IBOutlet weak var unnecessaryCountLabel: UILabel!
    @IBOutlet weak var emergencyCountLabel: UILabel!
    //各カテゴリを押した時のボタン
    @IBOutlet weak var emergencyImportantViewButton: UIButton!
    @IBOutlet weak var emergencyViewButton: UIButton!
    @IBOutlet weak var importantViewButton: UIButton!
    @IBOutlet weak var unnecessaryViewButton: UIButton!
    
    //上で定義したTodoItemの要素を配列としてデータを保持
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
        subViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        emergencyImportantViewButton.addTarget(self, action: #selector(emergencyImportantViewButtonTapped(_:)), for: .touchUpInside)
        
        emergencyViewButton.addTarget(self, action: #selector(emergencyViewButtonTapped(_:)), for: .touchUpInside)
        
        importantViewButton.addTarget(self, action: #selector(importantViewButtonTapped(_:)), for: .touchUpInside)
        
        unnecessaryViewButton.addTarget(self, action: #selector(unnecessaryViewButtonTapped(_:)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //タップされた時の動作
        subViewButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        subViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)
        
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
    
    //緊急＆重要をタップした時
    @IBAction func emergencyImportantViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmergencyImportantStoryboard", bundle: nil)
        //EmergencyImportantViewControllerの取得（画面遷移のため）
        guard let subVC = storyboard.instantiateViewController(withIdentifier: "EmergencyImportantViewController") as? EmergencyImportantViewController else{print("ViewControllerが見つかりません")
            return }
        
        subVC.todoItems = todoItems.filter { $0.category == "緊急＆重要" }
        
        //モーダル画面遷移
        self.present(subVC, animated: true)
    }
    
    //緊急をタップした時
    @IBAction func emergencyViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmergencyStoryboard", bundle: nil)
        //EmergencyViewControllerの取得（画面遷移のため）
        guard let subVC = storyboard.instantiateViewController(withIdentifier: "EmergencyViewController") as? EmergencyViewController else{print("ViewControllerが見つかりません")
            return }
        
        subVC.todoItems = todoItems.filter { $0.category == "緊急" }
        //モーダル画面遷移
        self.present(subVC, animated: true)
    }
    
    //重要をタップした時
    @IBAction func importantViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ImportantStoryboard", bundle: nil)
        //EmergencyViewControllerの取得（画面遷移のため）
        guard let subVC = storyboard.instantiateViewController(withIdentifier: "ImportantViewController") as? ImportantViewController else{print("ViewControllerが見つかりません")
            return }
        
        subVC.todoItems = todoItems.filter { $0.category == "重要" }
        //モーダル画面遷移
        self.present(subVC, animated: true)
    }
    
    @IBAction func unnecessaryViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "UnnecessaryStoryboard", bundle: nil)
        //UnnecessaryViewControllerの取得（画面遷移のため）
        guard let subVC = storyboard.instantiateViewController(withIdentifier: "UnnecessaryViewController") as? UnnecessaryViewController else{print("ViewControllerが見つかりません")
            return }
        
        subVC.todoItems = todoItems.filter { $0.category == "不要" }
        //モーダル画面遷移
        self.present(subVC, animated: true)
    }
    
    func didAddTodoItem(title: String, message: String, category: String) {
        let newItem: TodoItem = TodoItem(title: title, message: message, category: category)
        todoItems.append(newItem)
        //データの更新
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let item = todoItems[indexPath.row]
        cell.titleLabel?.text = item.title
        cell.messageLabel?.text = item.message
        //件数更新
        emergencyImportantCountLabel.text = "\(todoItems.filter({ $0.category == "緊急＆重要" }).count)"
        importantCountLabel.text = "\(todoItems.filter({ $0.category == "重要" }).count)"
        unnecessaryCountLabel.text = "\(todoItems.filter({ $0.category == "不要" }).count)"
        emergencyCountLabel.text = "\(todoItems.filter({ $0.category == "緊急" }).count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    

    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
    
}


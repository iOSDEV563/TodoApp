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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = todoItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.message
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


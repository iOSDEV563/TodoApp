//
//  MainViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

struct TodoItem: Codable {
    var title: String
    var message: String
    var category: String
}

class ViewController: UIViewController, SubViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - アウトレット
    @IBOutlet weak var subViewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emergencyImportantCountLabel: UILabel!
    @IBOutlet weak var importantCountLabel: UILabel!
    @IBOutlet weak var unnecessaryCountLabel: UILabel!
    @IBOutlet weak var emergencyCountLabel: UILabel!
    @IBOutlet weak var emergencyImportantViewButton: UIButton!
    @IBOutlet weak var emergencyViewButton: UIButton!
    @IBOutlet weak var importantViewButton: UIButton!
    @IBOutlet weak var unnecessaryViewButton: UIButton!
    
    // MARK: - プロパティ
    var todoItems: [TodoItem] = []
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTodoItems()
        updateCategoryCountLabels()
        
        // 各ボタンのアクション設定
        subViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        emergencyImportantViewButton.addTarget(self, action: #selector(emergencyImportantViewButtonTapped(_:)), for: .touchUpInside)
        emergencyViewButton.addTarget(self, action: #selector(emergencyViewButtonTapped(_:)), for: .touchUpInside)
        importantViewButton.addTarget(self, action: #selector(importantViewButtonTapped(_:)), for: .touchUpInside)
        unnecessaryViewButton.addTarget(self, action: #selector(unnecessaryViewButtonTapped(_:)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - アクション
    @IBAction func buttonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SubStoryboard", bundle: nil)
        guard let subViewController = storyboard.instantiateViewController(withIdentifier: "SubViewController") as? SubViewController else {
            print("ViewControllerが見つかりません")
            return
        }
        subViewController.delegate = self
        self.present(subViewController, animated: true)
    }
    // 「緊急＆重要」カテゴリを表示
    @IBAction func emergencyImportantViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmergencyImportantStoryboard", bundle: nil)
        guard let emergencyImportantViewController = storyboard.instantiateViewController(withIdentifier: "EmergencyImportantViewController") as? EmergencyImportantViewController else {
            print("ViewControllerが見つかりません")
            return
        }
        emergencyImportantViewController.todoItems = todoItems.filter { $0.category == "緊急＆重要" }
        self.present(emergencyImportantViewController, animated: true)
    }
    // 「緊急」カテゴリを表示
    @IBAction func emergencyViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmergencyStoryboard", bundle: nil)
        guard let emergencyViewController = storyboard.instantiateViewController(withIdentifier: "EmergencyViewController") as? EmergencyViewController else {
            print("ViewControllerが見つかりません")
            return
        }
        emergencyViewController.todoItems = todoItems.filter { $0.category == "緊急" }
        self.present(emergencyViewController, animated: true)
    }
    // 「重要」カテゴリを表示
    @IBAction func importantViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ImportantStoryboard", bundle: nil)
        guard let importantViewController = storyboard.instantiateViewController(withIdentifier: "ImportantViewController") as? ImportantViewController else {
            print("ViewControllerが見つかりません")
            return
        }
        importantViewController.todoItems = todoItems.filter { $0.category == "重要" }
        self.present(importantViewController, animated: true)
    }
    // 「不要」カテゴリを表示
    @IBAction func unnecessaryViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "UnnecessaryStoryboard", bundle: nil)
        guard let unnecessaryViewController = storyboard.instantiateViewController(withIdentifier: "UnnecessaryViewController") as? UnnecessaryViewController else {
            print("ViewControllerが見つかりません")
            return
        }
        unnecessaryViewController.todoItems = todoItems.filter { $0.category == "不要" }
        self.present(unnecessaryViewController, animated: true)
    }
    
    // MARK: - SubViewControllerDelegate
    func didAddTodoItem(title: String, message: String, category: String) {
        let newItem = TodoItem(title: title, message: message, category: category)
        todoItems.append(newItem)
        tableView.reloadData()
        updateCategoryCountLabels()
        saveTodoItems()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTodoCell", for: indexPath) as? MainTodoCell else {
            fatalError( "セルの再利用に失敗しました")
        }
        let item = todoItems[indexPath.row]
        cell.titleLabel?.text = item.title
        cell.messageLabel?.text = item.message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - カスタムメソッド
    func updateCategoryCountLabels() {
        // 各ラベルごとの件数を対応するラベルに表示
        emergencyImportantCountLabel.text = "\(todoItems.filter({ $0.category == "緊急＆重要" }).count)"
        importantCountLabel.text = "\(todoItems.filter({ $0.category == "重要" }).count)"
        unnecessaryCountLabel.text = "\(todoItems.filter({ $0.category == "不要" }).count)"
        emergencyCountLabel.text = "\(todoItems.filter({ $0.category == "緊急" }).count)"
    }
    
    func saveTodoItems() {
        // todoItemsをUserDefaultsに保存
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todoItems) {
            UserDefaults.standard.set(encoded, forKey: "todoItems")
        }
    }
    
    func loadTodoItems() {
        // UserDefaultsからtodoItemsを読み込む
        if let savedData = UserDefaults.standard.data(forKey: "todoItems") {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([TodoItem].self, from: savedData) {
                todoItems = loadedItems
            }
        }
    }
}

//
//  ViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/13.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    //    TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    //    FAB
    var startingFrame : CGRect!
    var endingFrame : CGRect!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.button.isHidden {
            self.button.isHidden = false
            self.button.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
                self.button.frame = self.endingFrame
            }
        }
    }
    func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        buttonを角丸にする
        button.layer.cornerRadius = 32
    }
    
    
}


struct TodoItem: Codable {
    var title: String
    var completed: Bool
}

struct TodoList: Codable {
    var items: [TodoItem]
}

// todoのリストを保存するクラス
class TodoListController {
    
    var todoList: TodoList
    
    init() {
        let defaults = UserDefaults.standard
        if let saveData = defaults.data(forKey: "TodoList"), let savedList = try? JSONDecoder().decode(TodoList.self, from: saveData) {
            todoList = savedList
        } else {
            todoList = TodoList(items: [])
        }
    }
    
    var todoItems: [TodoItem] {
        return todoList.items
    }
    
    // todoを追加する
    func addItem(title: String) {
        let newItem = TodoItem(title: title, completed: false)
        todoList.items.append(newItem)
        save()
    }
    
    // todoを削除する
    func removeItem(at index: Int) {
        todoList.items.remove(at: index)
        save()
    }
    
    // todoの達成flagを反転する
    func toggleCompleted(at index: Int) {
        todoList.items[index].completed.toggle()
        save()
    }
    
    // todoリストがアプリを消してもデータを保持する
    func save() {
        let defaults = UserDefaults.standard
        if let encodelist = try? JSONEncoder().encode(todoList) {
            defaults.setValue(encodelist, forKey: "TodoList")
        }
    }
}

class TodoListViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var todoListController = TodoListController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // +ボタンの選択の処理
    @IBAction func addTodoItem(_ sender: Any) {
        guard let title = textField.text, !title.isEmpty else {return}
        todoListController.addItem(title: title)
        tableView.reloadData()
        textField.text = ""
    }
    
}

extension TodoListViewController: UITableViewDataSource {
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListController.todoItems.count
    }
    
    //セルの生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todoItem = todoListController.todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.completed ? .checkmark : .none
        return cell
    }
    
    //セルをスワイプで削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoListController.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension TodoListViewController: UITableViewDelegate {
    
    //選択時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todoListController.toggleCompleted(at: indexPath.row)
        tableView.reloadData()
    }
}

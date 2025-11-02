//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/10/20.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadTodos()
    }
    
    func loadTodos() {
        DispatchQueue.global(qos: .userInitiated).async {
            let list = DatabaseManager.shared.fetchAll()
            DispatchQueue.main.async {
                self.todos = list
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addVC = storyboard.instantiateViewController(withIdentifier: "AddTodoViewController") as? AddTodoViewController else { return }
        addVC.onSave = { [weak self] in
            self?.loadTodos()
        }
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { todos.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.message
        cell.accessoryType = todo.isDone ? .checkmark : .none
        return cell
    }
    
    // スワイプ削除
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            guard let id = todo.id else {
                // idがないレコードは削除できない（DBに存在しない）
                let alert = UIAlertController(title: "エラー", message: "この項目は削除できません (id が不明)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let ok = DatabaseManager.shared.delete(id: id)
                DispatchQueue.main.async {
                    if ok {
                        self.todos.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        let alert = UIAlertController(title: "エラー", message: "削除に失敗しました", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    // タップで完了トグル
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var todo = todos[indexPath.row]
        // toggle
        todo.isDone.toggle()
        
        // 更新（idが必須）
        guard let id = todo.id else {
            let alert = UIAlertController(title: "エラー", message: "更新できません (id が不明)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let ok = DatabaseManager.shared.update(todo: todo)
            DispatchQueue.main.async {
                if ok {
                    self.todos[indexPath.row] = todo
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    let alert = UIAlertController(title: "エラー", message: "更新に失敗しました", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

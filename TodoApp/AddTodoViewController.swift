//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/10/20.
//

import UIKit

class AddTodoViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    // 保存後に呼ばれるクロージャ（リロード用）
    var onSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新規Todo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveTapped))
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            let alert = UIAlertController(title: "入力エラー", message: "タイトルを入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let msg = messageTextView.text ?? ""
        let category = categoryControl.selectedSegmentIndex
        let newTodo = Todo(
            id: 0, // insertで自動採番される想定。あなたのTodo型がid optionalなら nil にする
            title: titleText,
            message: msg,
            category: category,
            isDone: false,
            createdAt: Date()
        )
        
        DispatchQueue.global(qos: .userInitiated).async {
            let insertedId = DatabaseManager.shared.insert(todo: newTodo)
            DispatchQueue.main.async {
                if insertedId != nil {
                    self.onSave?()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "エラー", message: "保存に失敗しました", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}


//
//  SubViewContoroller.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

//プロトコル宣言ここで受け渡しの内容を記述
protocol SubViewControllerDelegate: AnyObject {
    func didAddTodoItem(title: String, message: String, category: String)
}



class SubViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: SubViewControllerDelegate?
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
        
    let categories = ["緊急＆重要", "緊急", "不要", "重要"]
    
    //閉じるボタンを押した時の処理
    @IBAction func closeSubViewButton(_ sender: UIButton) {
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //追加ボタンを押した時の処理
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let message = messageTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        //ここでmainにデータを受け渡し
        delegate?.didAddTodoItem(title: title, message: message, category: category)
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //カテゴリ選択
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
        toolBar.isHidden = !toolBar.isHidden
    }
    
    //pickerViewの選択決定
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem){
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedRow]
        categoryTextField.text = selectedCategory
        pickerView.isHidden = true
        toolBar.isHidden = true
        categoryTextField.textColor = .black
    }
    //pickerViewのcancelボタン
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        pickerView.isHidden = true
        toolBar.isHidden = true
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        
        toolBar.isHidden = true
        //カテゴリの枠線
        categoryTextField.layer.borderColor = UIColor.black.cgColor
        categoryTextField.layer.borderWidth = 1
        //タイトルの枠線
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        //メッセージの枠線
        messageTextField.layer.borderColor = UIColor.black.cgColor
        messageTextField.layer.borderWidth = 1
        
        
        categoryTextField.textColor = .gray

        // Do any additional setup after loading the view.
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

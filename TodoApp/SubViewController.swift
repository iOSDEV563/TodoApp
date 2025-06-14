//
//  SubViewContoroller.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

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
    
    
    @IBAction func closeSubViewButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let message = messageTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        
        delegate?.didAddTodoItem(title: title, message: message, category: category)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
        toolBar.isHidden = !toolBar.isHidden
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem){
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedRow]
        categoryTextField.text = selectedCategory
        pickerView.isHidden = true
        toolBar.isHidden = true
        categoryTextField.textColor = .black
    }
    
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
    
    /*func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryLabel.text = categories[row]
        categoryLabel.textColor = .black
        pickerView.isHidden = true
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        
        toolBar.isHidden = true
        
        categoryTextField.layer.borderColor = UIColor.black.cgColor
        categoryTextField.layer.borderWidth = 1
        
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
        
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

//
//  SubViewContoroller.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

class SubViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ClosePickerViewButton: UIButton!
    let categories = ["緊急＆重要", "緊急", "不要", "重要"]
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
        ClosePickerViewButton.isHidden = !ClosePickerViewButton.isHidden
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryLabel.text = categories[row]
        categoryLabel.textColor = .black
        pickerView.isHidden = true
        ClosePickerViewButton.isHidden = true
    }
    
    @IBOutlet weak var CategoryBoxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        ClosePickerViewButton.isHidden = true
        
      CategoryBoxView.layer.borderColor = UIColor.black.cgColor
        CategoryBoxView.layer.borderWidth = 1
        
        categoryLabel.textColor = .gray
        
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

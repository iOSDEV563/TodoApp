//
//  UnnecessaryViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/06/22.
//

import UIKit

class UnnecessaryViewController: UIViewController {
    
    @IBAction func closeunnecessaryViewButton(_ sender: UIButton) {
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

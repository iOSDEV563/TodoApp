//
//  EmergencyImportantViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/06/17.
//

import UIKit

class EmergencyImportantViewController: UIViewController {
    
    //閉じるボタンを押した時の処理
    @IBAction func closeEmergencyImportantViewButton(_ sender: UIButton) {
        //画面を閉じてmainに戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

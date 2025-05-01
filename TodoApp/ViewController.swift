//
//  MainViewController.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var subViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        
        //タップされた時の動作
        subViewButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    //タップされた時の処理
    @objc func buttonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SubStoryboard", bundle: nil)
        guard let SubViewController = storyboard.instantiateViewController(withIdentifier: "SubViewController") as? SubViewController else{print("ViewControllerが見つかりません")
            return }
        self.present(SubViewController, animated: true)
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


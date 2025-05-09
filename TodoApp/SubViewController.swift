//
//  SubViewContoroller.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/04/30.
//

import UIKit

class SubViewController: UIViewController {
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var CategoryBoxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      CategoryBoxView.layer.borderColor = UIColor.black.cgColor
        CategoryBoxView.layer.borderWidth = 1
        
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

//
//  EmergencyImportantTodoCell.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/07/03.
//

import UIKit

class EmergencyImportantTodoCell: UITableViewCell {
    
    // MARK: - アウトレット
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - ライフサイクル
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

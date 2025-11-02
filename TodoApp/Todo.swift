//
//  Todo.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/10/20.
//

import Foundation
import FMDB

struct Todo {
    let id: Int?
    let title: String
    let message: String?
    let category: Int
    let isDone: Bool
    let createdAt: Date
    
    init(id: Int? = nil, title: String, message: String? = nil, category: Int = 0, isDone: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.message = message
        self.category = category
        self.isDone = isDone
        self.createdAt = createdAt
    }
    
    // DB -> Todo
    init?(resultSet: FMResultSet) {
        // titleはNOT NULLなので必須取得
        guard let title = resultSet.string(forColumn: "title") else { return nil }
        let idVal = Int(resultSet.int(forColumn: "id"))
        // FMDBのint(forColumn:) は 0 を返すことがあるので NULL 観点は columnIsNull で確認
        self.id = resultSet.columnIsNull("id") ? nil : idVal
        self.title = title
        self.message = resultSet.string(forColumn: "message")
        self.category = Int(resultSet.int(forColumn: "category"))
        self.isDone = resultSet.bool(forColumn: "is_done")
        self.createdAt = Date(timeIntervalSince1970: resultSet.double(forColumn: "created_at"))
    }
    
    // Todo -> DBバインド用配列
    func toParameters() -> [Any] {
        return [
            title,
            message ?? NSNull(),
            category,
            isDone ? 1 : 0,
            createdAt.timeIntervalSince1970
        ]
    }
}

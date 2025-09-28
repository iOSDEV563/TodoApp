//
//  DatabaseManager.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/09/25.
//
import Foundation
import FMDB

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    // MARK: - DBパス取得
    func dbPath() -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("test.db").path
    }
    
    // MARK: - 初期コピー（必要なら強制上書き）
    func setupDatabase(forceOverwrite: Bool = false) {
        let fileManager = FileManager.default
        let path = dbPath()
        
        if fileManager.fileExists(atPath: path) && !forceOverwrite {
            print("DB file OK（既存ファイルを使用）")
            return
        }
        
        do {
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
                print("既存DBを削除しました")
            }
            
            guard let defaultDBPath = Bundle.main.path(forResource: "test", ofType: "db") else {
                print("バンドル内にtest.dbが見つかりません")
                return
            }
            
            try fileManager.copyItem(atPath: defaultDBPath, toPath: path)
            print("DBコピー完了: \(path)")
        } catch {
            print("DBセットアップエラー: \(error)")
        }
    }
    
    // MARK: - クエリ実行サンプル
    func fetchQuiz(qNum: Int) -> (question: String?, answer: String?, commentary: String?) {
        let db = FMDatabase(path: dbPath())
        guard db.open() else {
            print("DBオープン失敗")
            return (nil, nil, nil)
        }
        
        let sql = "SELECT * FROM quiz_tb WHERE id = ?;"
        var question: String? = nil
        var answer: String? = nil
        var commentary: String? = nil
        
        if let results = try? db.executeQuery(sql, values: [qNum]) {
            while results.next() {
                question = results.string(forColumn: "question")
                answer = results.string(forColumn: "answer")
                commentary = results.string(forColumn: "commentary")
            }
        } else {
            print("クエリ実行失敗: \(db.lastErrorMessage())")
        }
        
        db.close()
        return (question, answer, commentary)
    }
}

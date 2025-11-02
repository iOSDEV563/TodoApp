//
//  DatabaseManager.swift
//  TodoApp
//
//  Created by 鈴木康大 on 2025/09/25.
//
import Foundation
import FMDB

final class DatabaseManager {
    // MARK: - シングルトン（アプリ全体で1つだけ使う）
    static let shared = DatabaseManager()
    
    // MARK: - プロパティ
    private let queue: FMDatabaseQueue
    private let dbFileName = "todos.sqlite"
    
    // MARK: - 初期化処理
    private init() {
        // ドキュメントフォルダのパスを取得（アプリごとに保存される安全な領域）
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: true)
        // SQLiteファイルのパスを作成
        let dbURL = documentsURL.appendingPathComponent(dbFileName)
        
        // FMDatabaseQueueを作成（スレッド安全に操作できるキュー）
        queue = FMDatabaseQueue(path: dbURL.path)!
        
        // アプリ初回起動時などにテーブルがなければ作成
        createTablesIfNeeded()
    }
    
    // MARK: - テーブル作成
    private func createTablesIfNeeded() {
        let sql = """
        CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            message TEXT,
            category INTEGER NOT NULL,
            is_done INTEGER NOT NULL DEFAULT 0,
            created_at REAL NOT NULL
        );
        """
        
        queue.inDatabase { db in
            do {
                try db.executeUpdate(sql, values: nil)
                print("✅ テーブル作成または存在確認OK")
            } catch {
                print("⚠️ テーブル作成エラー: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Todo追加（INSERT）
    func insert(todo: Todo) -> Int? {
        var lastId: Int?
        let sql = "INSERT INTO todos (title, message, category, is_done, created_at) VALUES (?, ?, ?, ?, ?)"
        queue.inDatabase { db in
            do {
                try db.executeUpdate(sql, values: todo.toParameters())
                lastId = Int(db.lastInsertRowId)
                print("🟢 データ追加成功 (id = \(lastId ?? 0))")
            } catch {
                print("❌ INSERT失敗: \(error.localizedDescription)")
            }
        }
        return lastId
    }
    
    // MARK: - Todo一覧取得（SELECT）
    func fetchAll() -> [Todo] {
        var todos: [Todo] = []
        
        let sql = "SELECT * FROM todos ORDER BY created_at DESC"
        
        queue.inDatabase { db in
            do {
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    if let todo = Todo(resultSet: rs) {
                        todos.append(todo)
                    }
                }
                rs.close()
                print("データ取得 \(todos.count) 件")
            } catch {
                print("SELECT失敗: \(error.localizedDescription)")
            }
        }
        
        return todos
    }
    
    // MARK: - Todo更新（UPDATE）
    func update(todo: Todo) -> Bool {
        guard let id = todo.id else { return false }
        let sql = "UPDATE todos SET title = ?, message = ?, category = ?, is_done = ? WHERE id = ?"
        var sucsess = false
        queue.inDatabase { db in
            do {
                try db.executeUpdate(sql, values: [todo.title, todo.message ?? NSNull(), todo.category, todo.isDone ? 1 : 0, id])
                sucsess = true
                print("🟡 更新成功 (id = \(id))")
            } catch {
                print("❌ UPDATE失敗: \(error.localizedDescription)")
            }
        }
        return sucsess
    }
    }
    
    // MARK: - Todo削除（DELETE）
    func delete(id: Int) -> Bool {
        let sql = "DELETE FROM todos WHERE id = ?"
        var success = false
        
        queue.inDatabase { db in
            do {
                try db.executeUpdate(sql, values: [id])
                success = true
                print("削除成功 (id = \(id))")
            } catch {
                print("DELETE失敗: \(error.localizedDescription)")
            }
        }
        
        return success
    }
}

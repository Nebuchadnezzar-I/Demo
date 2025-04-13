//
//  DB.swift
//  Demo
//
//  Created by Michal Ukropec on 13/04/2025.
//

import Foundation
import SQLite3

struct Negotiation: Identifiable {
    let id: UUID
    let name: String
}

final class Database {
    static let shared = Database()

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createNegotiationsTable()
    }

    private func openDatabase() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AppDatabase.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ Unable to open database")
        }
    }

    private func createNegotiationsTable() {
        let query = """
            CREATE TABLE IF NOT EXISTS negotiations (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL
            );
            """
        run(query)
    }

    private func run(_ query: String) {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("❌ Error executing: \(query)")
            }
        } else {
            print("❌ Prepare failed: \(query)")
        }
        sqlite3_finalize(stmt)
    }

    func insertNegotiation(id: UUID = UUID(), name: String) {
        DispatchQueue.global(qos: .utility).async {
            let query = "INSERT INTO negotiations (id, name) VALUES (?, ?);"
            var stmt: OpaquePointer?

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                sqlite3_bind_text(stmt, 1, id.uuidString, -1, nil)
                sqlite3_bind_text(stmt, 2, name, -1, nil)

                if sqlite3_step(stmt) != SQLITE_DONE {
                    print("❌ Failed to insert negotiation")
                } else {
                    print("✅ Inserted \(name)")
                }
            } else {
                print("❌ Prepare insert failed")
            }

            sqlite3_finalize(stmt)
        }
    }

    func fetchNegotiations(completion: @escaping ([Negotiation]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let query = "SELECT id, name FROM negotiations;"
            var stmt: OpaquePointer?
            var results: [Negotiation] = []

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    if let cId = sqlite3_column_text(stmt, 0),
                        let cName = sqlite3_column_text(stmt, 1),
                        let uuid = UUID(uuidString: String(cString: cId))
                    {
                        let name = String(cString: cName)
                        results.append(Negotiation(id: uuid, name: name))
                    }
                }
            } else {
                print("❌ Failed to prepare fetch")
            }

            sqlite3_finalize(stmt)

            // Return results on main thread
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }

}

import Foundation
import SwiftData

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            return "sqlite3 \"\(url)\""
        } else {
            return "No SQLite database found."
        }
    }
}

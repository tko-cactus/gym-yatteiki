//
//  SampleLoadByMenu.swift
//  gym-yatteiki
//
//  Created by Yamaguchi Tokio on 2024/07/16.
//

import Foundation
import SwiftData

@MainActor
class SampleLoadByMenuArray {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: LoadByMenu.self, Menu.self, configurations: config)
            
            // ダミーデータの作成
            let menu = Menu(name: "Example Menu", type: .CHEST)
            container.mainContext.insert(menu)
            
            for i in 1 ... 3 {
                let loadByMenu = LoadByMenu.create(menu: menu, rest: 60)
                container.mainContext.insert(loadByMenu)
            }
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}

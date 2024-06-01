//
//  ChatBotApp.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI
import SwiftData

@main
struct ChatBotApp: App {    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: History.self)
    }
}

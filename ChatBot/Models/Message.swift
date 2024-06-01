//
//  Message.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import Foundation
import SwiftData

@Model
class Message: Hashable, Identifiable {
    var id = UUID()
    var date = Date()
    var content: String
    var isCurrentUser: Bool
    var wasLoaded: Bool = false
    
    init(content: String, isCurrentUser: Bool, wasLoaded: Bool = false) {
        self.content = content
        self.isCurrentUser = isCurrentUser
        self.wasLoaded = wasLoaded
    }
    
    static let example = Message(content: "This is test message", isCurrentUser: true)
}

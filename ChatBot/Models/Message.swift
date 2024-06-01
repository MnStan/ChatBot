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
    var similarityLevel: Double
    
    init(content: String, isCurrentUser: Bool, wasLoaded: Bool = false, similarityLevel: Double = 0.0) {
        self.content = content
        self.isCurrentUser = isCurrentUser
        self.wasLoaded = wasLoaded
        self.similarityLevel = similarityLevel
    }
    
    static let example = Message(content: "This is test message", isCurrentUser: true, similarityLevel: 1.0)
}

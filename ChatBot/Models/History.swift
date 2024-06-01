//
//  History.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 29/05/2024.
//

import Foundation
import SwiftData

@Model
class History: Identifiable {
    var id: UUID
    var date: Date
    var messages: [Message]
    
    init(messages: [Message]) {
        self.id = UUID()
        self.date = .now
        self.messages = messages
    }
}

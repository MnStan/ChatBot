//
//  Message.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import Foundation

struct Message: Hashable {
    var id = UUID()
    var content: String
    var isCurrentUser: Bool
}

//
//  DateFormatter+ext.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 01/06/2024.
//

import Foundation

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

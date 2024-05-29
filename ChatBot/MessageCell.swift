//
//  MessageCell.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI

struct MessageCell: View {
    @State private var displayedText = ""
    @State private var isTyping = true
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        HStack {
            Text(displayedText)
                .padding(10)
                .background(isCurrentUser ? Color.gray : nil)
                .cornerRadius(20)
                .fixedSize(horizontal: false, vertical: true)
                .onAppear {
                    startTypewritterAnimation()
                }
            
            if isTyping && isCurrentUser == false {
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(isTyping ? 1.2 : 1.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isTyping)
            }
        }
    }
    
    private func startTypewritterAnimation() {
        print(isTyping)
        displayedText = ""
        let fullTextArray = Array(contentMessage)
        for (index, character) in fullTextArray.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02 * Double(index)) {
                displayedText.append(character)
                
                if index == fullTextArray.count - 1 {
                    isTyping = false
                }
            }
        }
    }
}

#Preview {
    MessageCell(contentMessage: "This is a single message cell. This is a single message cell.This is a single message cell.This is a single message cell.This is a single message cell.This is a single message cell.", isCurrentUser: false)
}

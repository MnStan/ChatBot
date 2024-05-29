//
//  MessageView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI

struct MessageView : View {
    var currentMessage: Message
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if !currentMessage.isCurrentUser {
                ZStack(alignment: .center) {
                    Circle()
                        .stroke(.gray, lineWidth: 2)
                        .frame(width: 25, height: 25)
                    
                    Image(systemName: "brain.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(5)
                }
            } else {
                Spacer()
            }
            
            MessageCell(contentMessage: currentMessage.content,
                        isCurrentUser: currentMessage.isCurrentUser)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


#Preview {
    MessageView(currentMessage: Message(content: "This is a single message cell with avatar. If user is current user avatar is not displayed.", isCurrentUser: false))
}

//
//  MessageView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI

struct MessageView : View {
    @Binding var shouldCallRepeat: Bool
    var currentMessage: Message
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
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
                .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }
            } else {
                Spacer()
            }
            
            MessageCell(shouldRepeat: $shouldCallRepeat, contentMessage: currentMessage.content,
                        isCurrentUser: currentMessage.isCurrentUser)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    MessageView(shouldCallRepeat: .constant(false), currentMessage: Message(content: "This is a single message cell with avatar. If user is current user avatar is not displayed.", isCurrentUser: false))
        .frame(height: 500)
}

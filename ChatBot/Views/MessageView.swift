//
//  MessageView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI

struct MessageView : View {
    @Binding var shouldCallRepeat: Bool
    @Binding var isShowingAnswer: Bool
    @Binding var currentMessage: Message
    @Binding var isLast: Bool
    @Binding var similarityLevel: Double
    
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
            
            MessageCell(shouldRepeat: $shouldCallRepeat, isShowingAnswer: $isShowingAnswer, currentMessage: $currentMessage, isLast: $isLast, similarityLevel: $similarityLevel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    MessageCell(shouldRepeat: .constant(false), isShowingAnswer: .constant(true), currentMessage: .constant(.example), isLast: .constant(true), similarityLevel: .constant(1.0))
        .frame(height: 500)
}

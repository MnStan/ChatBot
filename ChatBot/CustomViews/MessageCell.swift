//
//  MessageCell.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct MessageCell: View {
    @State private var displayedText = ""
    @State private var isTyping = true
    @State private var isCopyButtonHovered = false
    @State private var isRepeatButtonHovered = false
    @Binding var shouldRepeat: Bool
    @Binding var isShowingAnswer: Bool
    @Binding var currentMessage: Message
    @Binding var isLast: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(displayedText)
                    .padding(10)
                    .background(currentMessage.isCurrentUser ? Color.gray : nil)
                    .cornerRadius(20)
                    .fixedSize(horizontal: false, vertical: true)
                    .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.firstTextBaseline] }
                    .onAppear {
                        shouldRepeat = false
                        isShowingAnswer = !currentMessage.wasLoaded
                        
                        if currentMessage.isCurrentUser {
                            displayedText = currentMessage.content
                            currentMessage.wasLoaded = true
                        } else {
                            if currentMessage.wasLoaded == true {
                                displayedText = currentMessage.content
                                isTyping = false
                                isShowingAnswer = false
                            } else {
                                startTypewritterAnimation()
                            }
                        }
                    }
                
                if isTyping && currentMessage.isCurrentUser == false {
                    Circle()
                        .frame(width: 10, height: 10)
                        .scaleEffect(isShowingAnswer ? 1.0 : 1.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isShowingAnswer)
                }
            }
            
            if !currentMessage.isCurrentUser {
                HStack {
                    Button {
                        copyToClipboard(text: currentMessage.content)
                    } label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(isCopyButtonHovered ? .gray.opacity(0.2) : Color.clear)
                            Image(systemName: "doc.on.doc.fill")
                        }
                    }
                    .buttonStyle(.borderless)
                    .onHover(perform: { hovering in
                        withAnimation {
                            isCopyButtonHovered = hovering
                        }
                    })
                    .frame(width: 25, height: 25)
                    .scaleEffect(isCopyButtonHovered ? 1.2 : 1.0)

                    if isLast {
                        Button {
                            shouldRepeat = true
                            print("Repeating?")
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(isRepeatButtonHovered ? .gray.opacity(0.2) : Color.clear)
                                Image(systemName: "arrow.clockwise.circle.fill")
                            }
                        }
                        .buttonStyle(.borderless)
                        .onHover(perform: { hovering in
                            withAnimation {
                                isRepeatButtonHovered = hovering
                            }
                        })
                        .frame(width: 25, height: 25)
                        .scaleEffect(isRepeatButtonHovered ? 1.2 : 1.0)
                    }
                }
                        .padding(.leading, 10)
                        .opacity(isTyping ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isTyping)
            }
        }
    }
    
    private func startTypewritterAnimation() {
        displayedText = ""
        let fullTextArray = Array(currentMessage.content)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for (index, character) in fullTextArray.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02 * Double(index)) {
                    displayedText.append(character)
                    if index == fullTextArray.count - 1 {
                        withAnimation {
                            isTyping = false
                        }
                        isShowingAnswer = false
                        currentMessage.wasLoaded = true
                    }
                }
            }
        }
    }
    
    private func copyToClipboard(text: String) {
#if canImport(UIKit)
        UIPasteboard.general.string = text
#elseif canImport(AppKit)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
#endif
    }
}

#Preview {
    MessageCell(shouldRepeat: .constant(false), isShowingAnswer: .constant(true), currentMessage: .constant(.example), isLast: .constant(true))
}

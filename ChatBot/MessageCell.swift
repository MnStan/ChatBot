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
    @State private var isAnimatingCircle = false
    @State private var isCopyButtonHovered = false
    @State private var isRepeatButtonHovered = false
    @Binding var shouldRepeat: Bool
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(displayedText)
                    .padding(5)
                    .background(isCurrentUser ? Color.gray : nil)
                    .cornerRadius(20)
                    .fixedSize(horizontal: false, vertical: true)
                    .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.firstTextBaseline] }
                    .onAppear {
                        shouldRepeat = false
                        isAnimatingCircle = true
                        if isCurrentUser {
                            displayedText = contentMessage
                        } else {
                            startTypewritterAnimation()
                        }
                    }
                
                if isTyping && isCurrentUser == false {
                    Circle()
                        .frame(width: 10, height: 10)
                        .scaleEffect(isAnimatingCircle ? 1.0 : 1.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimatingCircle)
                }
            }
            
            if isTyping == false && !isCurrentUser {
                HStack {
                    Button {
                        copyToClipboard(text: contentMessage)
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
                    
                    Button {
                        shouldRepeat = true
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
                .padding(.leading, 10)
            }
        }
    }
    
    private func startTypewritterAnimation() {
        displayedText = ""
        let fullTextArray = Array(contentMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for (index, character) in fullTextArray.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02 * Double(index)) {
                    displayedText.append(character)
                    if index == fullTextArray.count - 1 {
                        isTyping = false
                        isAnimatingCircle = false
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
    MessageCell(shouldRepeat: .constant(false), contentMessage: "This is a single message cell. This is a single message cell.This is a single message cell.This is a single message cell.This is a single message cell.This is a single message cell.", isCurrentUser: false)
}

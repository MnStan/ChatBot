//
//  ContentView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI
import PythonKit

struct ContentView: View {
    @State private var answer = ""
    @State private var isShowingAnswer = false
    @State private var question = ""
    @State private var shouldRepeat = false
    @State var messages: [Message] = []
    
    var body: some View {
        VStack {
            if messages.isEmpty {
                ContentUnavailableView("Start your conversation", systemImage: "brain.filled.head.profile", description: Text("You can ask whatever you want! Have fun!"))
            } else {
                List($messages, id: \.self) { message in
                    MessageView(shouldCallRepeat: $shouldRepeat, isShowingAnswer: $isShowingAnswer, currentMessage: message, isLast: .constant(isLastMessage(message.wrappedValue)))

                        .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.3))
                
                HStack(alignment: .bottom) {
                    TextField("Send question to Chat", text: $question, axis: .vertical)
                        .lineLimit(5)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 400)
                        .frame(minHeight: 25)
                        .padding(8)
                        .padding(.leading, 10)
                    
                    Button {
                        messages.append(Message(content: question, isCurrentUser: true))
                        testPython(question)
                        question = ""
                    } label: {
                        if isShowingAnswer {
                            LoadingDotsView()
                                .frame(width: 25, height: 25)
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(8)
                    .buttonStyle(PlainButtonStyle())
                    .keyboardShortcut(.defaultAction)
                    .disabled(isShowingAnswer || question.isEmpty)
                }
            }
            .fixedSize(horizontal: true, vertical: true)
        }
        .padding()
        .frame(maxWidth: 600)
        .onChange(of: shouldRepeat) { _, newValue in
            if newValue {
                messages.removeLast()
                testPython(question)
            }
        }
    }
    
    private func testPython(_ question: String) {
        let sys = Python.import("sys")
        sys.path.append("/Users/stan/Desktop/Swift/ChatBot/ChatBot/")
        let file = Python.import("LevianPythonScript")
        
        messages.append(Message(content: String(describing: file.getAnswer(text: question)), isCurrentUser: false))
    }

    private func isLastMessage(_ message: Message) -> Bool {
        messages.last == message
    }
}

#Preview {
    ContentView()
}

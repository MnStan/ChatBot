//
//  ContentView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 28/05/2024.
//

import SwiftUI
import PythonKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var answer = ""
    @State private var isShowingAnswer = false
    @State private var question = ""
    @State private var shouldRepeat = false
    @Binding var messages: [Message]
    @State var history: History?
    
    var startNewChat: (History) -> Void
    
    var body: some View {
        VStack {
            if messages.isEmpty {
                ContentUnavailableView("Start your conversation", systemImage: "brain.filled.head.profile", description: Text("You can ask whatever you want! Have fun!"))
            } else {
                
                ScrollViewReader { proxy in
                    List($messages, id: \.self) { message in
                        MessageView(shouldCallRepeat: $shouldRepeat, isShowingAnswer: $isShowingAnswer, currentMessage: message, isLast: .constant(isLastMessage(message.wrappedValue)))
                            .id(message.wrappedValue.id)
                            .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .onChange(of: messages.count) {
                        withAnimation {
                            if let lastMessage = messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
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
                        let newMessage = Message(content: question, isCurrentUser: true)
                        createNewHistory()
                        messages.append(newMessage)
                        testPython(question)
                        history?.messages.append(newMessage)
                        try? modelContext.save()
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
        sys.path.append("/Users/stan/Desktop/Swift/ChatBot/ChatBot/PythonFiles/")
        let file = Python.import("LevianPythonScript")
        
        let newMessage = Message(content: String(describing: file.getAnswer(text: question)), isCurrentUser: false)
        messages.append(newMessage)
        history?.messages.append(newMessage)
        try? modelContext.save()
    }
    
    private func isLastMessage(_ message: Message) -> Bool {
        messages.last == message
    }
    
    private func createNewHistory() {
        if messages.isEmpty {
            let newHistory = History(messages: [])
            startNewChat(newHistory)
            modelContext.insert(newHistory)
            history = newHistory
        }
    }
}

#Preview {
    ContentView(messages: .constant([]), startNewChat: {_ in })
}
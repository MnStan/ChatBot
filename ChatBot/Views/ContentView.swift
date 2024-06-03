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
    var algorithms = ["All", "Levenshtein", "Levenshtein Replacement", "Levenshtein Swapping", "Hamming", "Jaro Winkler", "Cosine", "Jaccard", "Qgram"]
    @State private var selectedAlgorithm = 0
    @State private var similarity = 0.6
    
    var body: some View {
        VStack {
            Slider(value: $similarity, in: 0...1, step: 0.05) {
                Text("Similarity \(similarity, specifier: "%.2f")")
            }
            
            if messages.isEmpty {
                ContentUnavailableView("Start your conversation", systemImage: "brain.filled.head.profile", description: Text("You can ask whatever you want! Have fun!"))
            } else {
                ScrollViewReader { proxy in
                    List($messages, id: \.self) { message in
                        MessageView(shouldCallRepeat: $shouldRepeat, isShowingAnswer: $isShowingAnswer, currentMessage: message, isLast: .constant(isLastMessage(message.wrappedValue)), similarityLevel: .constant(message.similarityLevel.wrappedValue))
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
        .padding(5)
        .frame(maxWidth: 600)
        .onChange(of: shouldRepeat) { _, newValue in
            if newValue {
                messages.removeLast()
                if let lastQuestion = messages.last?.content {
                    testPython(lastQuestion)
                }
            }
        }
        .toolbar {
            Picker(selection: $selectedAlgorithm) {
                ForEach(Array(algorithms.enumerated()), id: \.offset) { offset, algorithm in
                    Text(algorithm).tag(offset)
                }
                
                Section {
                    Slider(value: $similarity, in: 0...1, step: 0.15) {
                        Text("Similarity \(similarity, specifier: "%.2f")")
                    }
                }
            } label: {
                Text(algorithms[selectedAlgorithm])
            }
        }
    }
    
    private func testPython(_ question: String) {
        let sys = Python.import("sys")
        sys.path.append("/Users/stan/Desktop/Swift/ChatBot/ChatBot/PythonFiles/")
        let file = Python.import("Chatbot")
        let pythonReturn = file.getAnswer(text: question, algorithm: selectedAlgorithm, userSimilarity: similarity)
        
        let newMessage = Message(content: String(describing: pythonReturn[0]), isCurrentUser: false, similarityLevel: Double(pythonReturn[1]) ?? 0.0)
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

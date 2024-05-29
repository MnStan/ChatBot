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
    
    @State var messages: [Message] = []
    
    var body: some View {
        VStack {
            List(messages, id: \.self) { message in
                MessageView(currentMessage: message)
                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            HStack {
                TextField("Pytanie", text: $question, prompt: Text("Co tam"))
                    .frame(width: 400)
                
                Button("Get") {
                    messages.append(Message(content: question, isCurrentUser: true))
                    testPython(question)
                    question = ""
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
    }
    
    func testPython(_ question: String) {
        let sys = Python.import("sys")
        sys.path.append("/Users/stan/Desktop/Swift/ChatBot/ChatBot/")
        let file = Python.import("LevianPythonScript")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(Message(content: String(describing: file.getAnswer(text: question)), isCurrentUser: false))
        }
    }
}

#Preview {
    ContentView()
}

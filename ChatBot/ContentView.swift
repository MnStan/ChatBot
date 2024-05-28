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
    
    var body: some View {
        ZStack {
            Color.gray
            VStack {
                if isShowingAnswer {
                    Text(answer)
                }
                
                
                Button("Test") {
                    testPython()
                }
            }
            .padding()
        }
    }
    
    func testPython() {
        let sys = Python.import("sys")
        sys.path.append("/Users/stan/Desktop/Swift/ChatBot/ChatBot/")
        let file = Python.import("LevianPythonScript")
        
        answer = String(describing: file.getAnswer(text: "Hello how are you doing?"))
        isShowingAnswer.toggle()
    }
}

#Preview {
    ContentView()
}

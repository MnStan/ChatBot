//
//  MainView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 29/05/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            Text("History")
        } detail: {
            ContentView()
        }

    }
}

#Preview {
    MainView()
}

//
//  MainView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 29/05/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \History.date, order: .reverse) private var history: [History]
    
    @State private var selectedChat: History?
    @State private var hoveringStates: [UUID: Bool] = [:]
    @State private var isAddButtonHovered = false
    @State private var isMenuButtonHovered = false
    @State private var searchText = ""
    
    private var filteredHisotry: [History] {
        if searchText.isEmpty {
            return history
        } else {
            return history.filter { $0.messages.contains { $0.content.localizedCaseInsensitiveContains(searchText) } }
        }
    }
    
    var body: some View {
        NavigationSplitView {
                List(filteredHisotry, id: \.id, selection: $selectedChat) { chat in
                    HStack {
                        if let firstMessage = chat.messages.sorted(by: { $0.date < $1.date }).first?.content {
                            Text(firstMessage)
                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button("Delete") {
                                deleteItem(chat: chat)
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .menuStyle(BorderlessButtonMenuStyle())
                        .menuIndicator(.hidden)
                        .frame(width: 30)
                    }
                    .tag(chat)
                }
                .searchable(text: $searchText, placement: .sidebar)
            
        } detail: {
            ContentView(messages: Binding(
                get: { selectedChat?.messages.sorted { $0.date < $1.date } ?? [] },
                set: { newMessages in
                    if let selectedChat = selectedChat {
                        selectedChat.messages = newMessages
                    }
                }
            ), startNewChat: { newChat in
                self.selectedChat = newChat
            })
        }
        .toolbar {
            Button {
                selectedChat = nil
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(isAddButtonHovered ? .gray.opacity(0.2) : Color.clear)
                    Image(systemName: "square.and.pencil")
                }
            }
            .buttonStyle(.borderless)
            .onHover { hovered in
                isAddButtonHovered = hovered
            }
            .frame(width: 25, height: 25)
        }
    }
    
    private func startNewChat() {
        let newChat = History(messages: [])
        modelContext.insert(newChat)
        selectedChat = newChat
    }
    
    private func deleteItem(chat: History) {
        withAnimation {
            modelContext.delete(chat)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: History.self, inMemory: true)
}

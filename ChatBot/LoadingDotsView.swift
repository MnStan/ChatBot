//
//  LoadingDotsView.swift
//  ChatBot
//
//  Created by Maksymilian Stan on 29/05/2024.
//

import SwiftUI

struct LoadingDotsView: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 10, height: 10)
                .offset(x: isLoading ? 3 : -3)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isLoading)
            Circle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 10, height: 10)
                .offset(x: isLoading ? 5 : -5)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isLoading)
            Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                .offset(x: isLoading ? 10 : -10)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isLoading)
        }
        .onAppear {
            withAnimation {
                isLoading = true
            }
        }
    }
}

#Preview {
    LoadingDotsView()
        .frame(width: 200, height: 200)
}

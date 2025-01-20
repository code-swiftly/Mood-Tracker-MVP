//
//  MainView.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/28/24.
//

import Foundation
import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @State var viewModel: SavedMoodViewModel
    
    init() {
        self.viewModel = SavedMoodViewModel()
    }
    
    var body: some View {
        TabView {
            MoodSelectionScreen(viewModel: viewModel)
                .tabItem {
                    Label("Mood Selection", systemImage: "square.and.pencil")
                }
            
            MoodHistoryView(viewModel: viewModel)
                .tabItem {
                    Label("Mood History", systemImage: "list.dash")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
        }
        .tint(Color.black)
        .onAppear {
            viewModel = SavedMoodViewModel(context: context)
        }
    }
}

#Preview {
    MainView()
}

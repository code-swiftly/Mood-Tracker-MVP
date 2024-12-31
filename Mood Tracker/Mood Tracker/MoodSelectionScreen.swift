//
//  ContentView.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/20/24.
//

import Foundation
import SwiftUI
import SwiftData

struct MoodSelectionScreen: View {
    var viewModel: SavedMoodViewModel
        
    var body: some View {
        ZStack {
            viewModel.selectedMood.color
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                BlobView(color: viewModel.selectedMood.color)
                    .onTapGesture {
                        viewModel.fetch()
                    }
                
                Spacer()
                
                Text(viewModel.selectedMood.rawValue)
                    .font(.title)
                
                Spacer()
                
                MoodSlider(viewModel: viewModel)
                
                Spacer()
                
                Button {
                    viewModel.save(mood: viewModel.selectedMood, date: Date())
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedMood.color)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(40)
        }
        
    }
}

struct BlobView: View {
    var color: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(color)
            .frame(width: 200, height: 200)
    }
}

struct MoodSlider: View {
    var viewModel: SavedMoodViewModel
    private let size: CGFloat = 40
    private let trackWidth: CGFloat = 300
    @State private var xValue: CGFloat = 0
    private let steps = 5
    
    var body: some View {
        let stepWidth = (trackWidth - size) / CGFloat(steps - 1)

        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: trackWidth, height: size)
                .opacity(0.2)
                .foregroundStyle(Color.gray)
            
            Circle()
                .frame(width: size, height: size)
                .offset(x: xValue)
                .foregroundStyle(Color.white)
                .shadow(radius: 1)
                .gesture(DragGesture().onChanged { value in
                    viewModel.updateMoodValue(sliderXValue: value.location.x,
                                              stepWidth: stepWidth,
                                              size: size,
                                              trackWidth: trackWidth)
                    xValue = CGFloat(viewModel.moodValue) * stepWidth
                })
        }
    }
}

#Preview {
    MoodSelectionScreen(viewModel: SavedMoodViewModel())
}

//
//  MoodHistoryView.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/28/24.
//

import SwiftUI
import SwiftData

struct MoodHistoryView: View {
    var viewModel: SavedMoodViewModel

    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            CalendarView(viewModel: viewModel)
        }
        
        .padding(.all, 20)
    }
}

struct HeaderView:View {
    var viewModel: SavedMoodViewModel

    var body: some View {
        HStack {
            Button {
                viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate)!
            } label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
            }
            Spacer()
            Text(viewModel.selectedDate, format: .dateTime.month(.wide).year())
                .font(.largeTitle)
            Spacer()
            Button {
                viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedDate)!
            } label: {
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
            }
        }
        .tint(.black)
    }
}

struct CalendarView: View {
    var viewModel: SavedMoodViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            DaysOfWeekView()
            DaysOfMonthView(viewModel: viewModel)
        }
    }
    
    struct DaysOfWeekView: View {
        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        var body: some View {
            ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
            }
        }
    }
    
    struct DaysOfMonthView: View {
        var viewModel: SavedMoodViewModel

        var body: some View {
            ForEach(viewModel.monthDays, id: \.self) { dayOfMonth in
                let moodForDay = viewModel.moodForDay(date: dayOfMonth)
                ZStack {
                    Circle()
                        .fill(moodForDay.color)
                        .frame(width: 40, height: 40)
                    Text(Calendar.current.component(.day, from: dayOfMonth).description)
                }
            }
        }
    }
}

#Preview {
    MoodHistoryView(viewModel: SavedMoodViewModel())
}

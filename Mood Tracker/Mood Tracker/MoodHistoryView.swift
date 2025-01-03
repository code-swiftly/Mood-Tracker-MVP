//
//  MoodHistoryView.swift
//  Mood Tracker
//
//  Created by Andy Couto on 12/28/24.
//

import SwiftUI
import SwiftData

struct TappedDate: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var mood: Mood
}

struct MoodHistoryView: View {
    var viewModel: SavedMoodViewModel
    
    @State var tappedDate: TappedDate?

    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            CalendarView(viewModel: viewModel, tappedDate: $tappedDate)
        }
        .sheet(item: $tappedDate) { tappedDate in
            MoodPickerSheet(tappedDate: $tappedDate, onSave: {
                mood in
                viewModel.save(mood: mood, date: tappedDate.date)
                self.tappedDate = nil
            }, dismiss: {
                self.tappedDate = nil
            })
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
    @Binding var tappedDate: TappedDate?
    
    var body: some View {
        LazyVGrid(columns: columns) {
            DaysOfWeekView()
            DaysOfMonthView(tappedDate: $tappedDate, viewModel: viewModel)
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
        @Binding var tappedDate: TappedDate?
        var viewModel: SavedMoodViewModel

        var body: some View {
            ForEach(viewModel.monthDays, id: \.self) { dayOfMonth in
                let moodForDay = viewModel.moodForDay(date: dayOfMonth)
                ZStack {
                    Circle()
                        .fill(moodForDay.color)
                        .frame(width: 40, height: 40)
                    Text(Calendar.current.component(.day, from: dayOfMonth).description)
                }.onTapGesture {
                    let today = Date().normalizedDate

                    if dayOfMonth <= today {
                        tappedDate = TappedDate(date: dayOfMonth, mood: moodForDay)
                    }
                }
            }
        }
    }
}

struct MoodPickerSheet: View {
    @Binding var tappedDate: TappedDate?
    let onSave: (Mood) -> Void
    let dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Mood")
                .font(.headline)
                .padding()
            
            ForEach(Mood.allCases, id: \.self) { mood in
                Button(action: {
                    onSave(mood)
                    dismiss()
                }) {
                    HStack {
                        Circle()
                            .fill(mood.color)
                            .frame(width: 20, height: 20)
                        Text(mood.rawValue.capitalized)
                            .padding()
                    }
                }
                .padding(5)
            }
        }
    }
}

#Preview {
    MoodHistoryView(viewModel: SavedMoodViewModel())
}

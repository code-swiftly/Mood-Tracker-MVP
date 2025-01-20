//
//  AnalyticsView.swift
//  Mood Tracker
//
//  Created by Andy Couto on 1/4/25.
//

import SwiftUI
import Charts
import SwiftData

struct AnalyticsView: View {
    @Environment(\.modelContext) private var context

    @State private var viewModel: AnalyticsViewModel

    init() {
        _viewModel = State(wrappedValue: AnalyticsViewModel())
    }
    
    var body: some View {
        MoodPieChartView(viewModel: viewModel)
            .onAppear {
                viewModel.setContext(context)
            }
    }
}

enum DateRange: String, CaseIterable {
    case last7Days = "Last 7 Days"
    case last30Days = "Last 30 Days"
}

struct MoodPieChartView: View {
    @State var viewModel: AnalyticsViewModel
    
    @State private var selectedRange: DateRange = .last7Days
        
    var body: some View {
        VStack {
            Picker("Select Range", selection: $selectedRange) {
                ForEach(DateRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Chart(pieChartData()) { data in
                SectorMark(
                    angle: .value("Percentage", data.percentage),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(0.9)
                )
                .foregroundStyle(data.mood.color)
                .annotation(position: .overlay) {
                    Text("\(Int(data.percentage))%")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 300)
            .padding()

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(mood.color)
                            .frame(width: 12, height: 12)
                        Text(mood.rawValue.capitalized)
                            .font(.caption)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    private func pieChartData() -> [MoodPieData] {
        let filteredMoods = filteredMoodsByDateRange()
        let counts = Dictionary(grouping: filteredMoods, by: { $0 }).mapValues { $0.count }
        let total = Double(filteredMoods.count)
        
        return Mood.allCases.compactMap { mood in
            guard let count = counts[mood], count > 0 else { return nil }
            return MoodPieData(mood: mood, percentage: (Double(count) / total) * 100)
        }
    }
    
    private func filteredMoodsByDateRange() -> [Mood] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: selectedRange == .last7Days ? -7 : -30, to: Date()) ?? Date()
        return viewModel.savedMoods
            .filter { $0.key >= cutoffDate }
            .map { $0.value }
    }
}

struct MoodPieData: Identifiable {
    let id = UUID()
    let mood: Mood
    let percentage: Double
}

@Observable class AnalyticsViewModel {
    private var context: ModelContext?

    var savedMoods: [Date: Mood] = [:]
    
    func setContext(_ context: ModelContext) {
        self.context = context
        fetch()
    }
    
    private func fetch() {
        do {
            if let fetchedMoods = try context?.fetch(FetchDescriptor<SavedMood>()) {
                savedMoods = Dictionary(uniqueKeysWithValues: fetchedMoods.map { ($0.date, $0.mood) })
            }
        } catch {
            print(error)
        }
    }
}

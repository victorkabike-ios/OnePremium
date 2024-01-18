//
//  CustomCalendar.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/11.
//

import Foundation
import SwiftUI
struct CalendarView: View {
    @Environment(\.calendar) var calendar
    @State private var month = Date()
    let dueDate: Date
    
    var body: some View {
        VStack {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.caption2)
                }
                Spacer()
                Text("\(month, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .font(.title)
            
            CalendarGridView(month: $month, dueDate: dueDate)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private func previousMonth() {
        month = calendar.date(byAdding: .month, value: -1, to: month) ?? month
    }
    
    private func nextMonth() {
        month = calendar.date(byAdding: .month, value: 1, to: month) ?? month
    }
}


struct CalendarGridView: View {
    @Environment(\.calendar) var calendar
    @Binding var month: Date
    let dueDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(weeksInMonth(), id: \.self) { week in
                HStack {
                    ForEach(week, id: \.self) { date in
                        Text("\(date, formatter: dateFormatter)")
                            .frame(maxWidth: .infinity)
                            .font(.caption2)
                            .padding(.vertical, 8)
                            .background(isSameDay(date, dueDate) ? Color.blue : Color.clear)
                            .foregroundColor(isSameDay(date, dueDate) ? Color.white : Color.primary)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private func weeksInMonth() -> [[Date]] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end) else { return [] }
        
        return Array(stride(from: monthFirstWeek.start, to: monthLastWeek.end, by: 7 * 24 * 60 * 60))
            .compactMap { weekStart in
                calendar.dateInterval(of: .weekOfMonth, for: weekStart)
            }
            .map { weekInterval in
                Array(stride(from: weekInterval.start, through: weekInterval.end, by: 24 * 60 * 60))
            }
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = calendar.dateComponents([.day, .month, .year], from: date1)
        let components2 = calendar.dateComponents([.day, .month, .year], from: date2)
        return components1 == components2
    }
}

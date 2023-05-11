//
//  MonthlySpendingChartView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/07.
//

import Foundation
import SwiftUI
import SwiftUICharts


struct Spending: Hashable{
    var id = UUID()
    var month:String
    var amount: Double
}

struct BarChartView: View {
    let data: [Spending]
    @State private var showBars = false
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
    // Currency Formating on Price
    func CurrencyPrice(price: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: price)) ?? ""
        
    }
    
    var body: some View {
        let maxAmount = data.map { $0.amount }.max() ?? 0
        HStack(alignment: .bottom, spacing: 35) {
            ForEach(0..<6) { index in
                let spending = data.first { $0.month == monthString(forIndex: index) }
                VStack {
//                    Text(spending != nil ? "\(spending!.amount)" : "")
//                        .font(.caption)
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 100)
                            .cornerRadius(4)
                            .scaleEffect(showBars ? 1 : 0, anchor: .bottom)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1).delay(Double(index) * 0.1)) {
                                    showBars = true
                                }
                            }
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .top, endPoint: .bottom)
                            .frame(width: 20, height: CGFloat((spending?.amount ?? 0) / maxAmount * 100))
                            .mask{
                                Rectangle()
                                .scaleEffect(showBars ? 1 : 0, anchor: .bottom)
                                .cornerRadius(4)
                                
                            }
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1).delay(Double(index) * 0.1)) {
                                    showBars = true
                                }
                            }
                    }
                    Text(monthString(forIndex: index))
                        .font(.caption)
                }
            }
        }
        .onAppear{
            withAnimation {
                            showBars.toggle()
                        }
        }
    }
    
    private func monthString(forIndex index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(byAdding: .month, value: -index, to: now).map { dateFormatter.string(from: $0) } ?? ""
    }
}

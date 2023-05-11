//
//  SubscriptionDetailView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/03/19.
//

import SwiftUI
import Charts

struct SubscriptionDetailView: View {
    var bill: Bill
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
    // Define a function that takes a date and returns a formatted string
    func formatDate(_ date: Date) -> String {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        // Set the date style
        dateFormatter.dateFormat = "dd MMMM"
        // Set the locale
        dateFormatter.locale = Locale(identifier: "en_US")
        // Return the formatted string
        return dateFormatter.string(from: date) }
   
    var body: some View {
        NavigationStack{
            ZStack{
                Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
                VStack(alignment: .center,spacing: 10){
                    VStack(alignment: .center){
                        Image(bill.image ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Text(bill.name ?? "")
                            .font(.title)
                            .foregroundColor(.primary)
                        Text(bill.notes ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    
                    VStack(alignment: .leading){
                    VStack(alignment:.leading,spacing: 8){
                        
                        CalendarView(dueDate: bill.dueDate!)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(Color.white)
                    }
                    Text("Upcoming payment \(formatDate(bill.dueDate!))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                    VStack{
                        HStack{
                            Image(systemName: "clock.arrow.circlepath")
                            Text("This bill will be charged every")
                                .font(.subheadline)
                            Spacer()
                            Text(bill.billCycle ?? "")
                                .font(.subheadline)
                            
                        }
                        Divider()
                        HStack{
                            Image(systemName: "bell.fill")
                            Text(bill.notification ? "Remind me 2 days before" : "You didn't set any reminder")
                                .font(.subheadline)
                            Spacer()
                            
                        }
                        
                    }.modifier(CustomModifier())
                    HStack{
                        Button {
                            
                        } label: {
                            Text("Cancel Subscription")
                                .foregroundColor(.blue)
                                .bold()
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame( height: 45)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.white)
                                }
                        }
                    }
                   
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
                .frame(maxHeight: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                       Text("Edit")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                       Text("Cancel")
                    }
                }
            }
        }
    }
    
}

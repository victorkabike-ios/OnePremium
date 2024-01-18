//
//  ContentView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/21.
//

import SwiftUI
import CoreData
import ScrollKit
import Charts

private extension View {

    func previewHeaderContent() -> some View {
        self.foregroundColor(.white)
            .shadow(color: .black.opacity(0.4), radius: 1, x: 1, y: 1)
    }
}

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // ScrollKit Parameters
    @State
       private var headerVisibleRatio: CGFloat = 1

       @State
       private var scrollOffset: CGPoint = .zero
        
    func handleScrollOffset(_ offset: CGPoint, headerVisibleRatio: CGFloat) {
          self.scrollOffset = offset
          self.headerVisibleRatio = headerVisibleRatio
      }
    
    // Creating a view model object to manage subscription service details
    @ObservedObject var  billViewModel =  BillsViewModel()
    
    @ObservedObject var paymentViewModel = PaymentViewModel()
    
    @State private var data: [Double] = []
    
    @State private var newSubscriptionButtonPressed: Bool = false
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
    @State var showSubscriptionDetail:Bool = false
    
    @State private var spendingIncreasePercentageText = ""
    
    @State private var isScaled = false
    
    @State private var monthlySpent:String?
    
    @State private var selectedbill: Bill?
    
    @State private var opacity: Double = 0
    
    // Define a state variable to store the percentage increase
        @State var percentageIncrease: String = ""
        
//        // Define a computed property to format the percentage increase as a String
//        var formattedPercentageIncrease: String {
//            // Create a number formatter
//            let numberFormatter = NumberFormatter()
//            numberFormatter.numberStyle = .percent
//            numberFormatter.maximumFractionDigits = 0
//
//            // Format the percentage increase as a String
//            return numberFormatter.string(from: NSNumber(value: percentageIncrease)) ?? "0%"
//        }
    var body: some View {
        NavigationStack{
            ScrollViewWithStickyHeader(header: Header, headerHeight: 140,onScroll: handleScrollOffset) {
                ScrollView{
                    let upcomingbills = billViewModel.fetchRecurringBills(viewContext: viewContext)
                    VStack(alignment: .leading, spacing: 30){
                        VStack(alignment: .leading){
                                VStack(alignment: .leading,spacing: 8){
                                    Text(billViewModel.CurrencyPrice(price: billViewModel.calculateMonthlySpending(viewContext: viewContext)))
                                        .font(.system(size: 38, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.blue)
                                    HStack{
                                        Text("Current month spending")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        // Create a Text view to display the formatted percentage increase
                                        HStack(spacing: 2){
                                            Image(systemName: "arrow.up.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(Color.green)
                                            Text("\(percentageIncrease)")
                                                .font(.subheadline)
                                                .foregroundColor(.green)
                                                .onAppear{
                                                    withAnimation(.easeInOut(duration: 0.8).delay(0.8)){
                                                        // Call the calculateSpendingIncrease function and assign the result to percentageIncrease
                                                        billViewModel.objectWillChange.send()
                                                        percentageIncrease = billViewModel.calculateSpendingIncrease(context: viewContext)
                                                        
                                                    }
                                                }
                                        }
                                    }
                                    BarChartView(data: billViewModel.monthlySpending(context: viewContext))
                                }
                        }
                        
                       
                        AccountsView()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .background {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundColor(Color.white)
                            }
                            .opacity(opacity)
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                                            opacity = 1
                                        }
                                    }
                        
                      
                        VStack{
                            HStack {
                                Text("Upcoming Payments")
                                Spacer()
                                Button(action: {}) {
                                    Text("Show All")
                                        .font(.caption)
                                }
                            }
                            VStack{
                                ForEach(upcomingbills, id: \.self) {bill in
                                    Button(action: {selectedbill = bill}) {
                                        SubscriptionListCellView(billViewModel: billViewModel, bill: bill)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .padding(.vertical)
                                    .background {
                                            RoundedRectangle(cornerRadius: 18)
                                            .foregroundColor(Color.white)
                                        }
                                }
                                .sheet(item: $selectedbill) { bill in
                                    SubscriptionDetailView(bill: bill)
                                }
                            }
                            
                        }.padding(.vertical)
                    }.padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                .padding(.top)
            }
            .background(Color.gray.opacity(0.2))
            .fullScreenCover(isPresented: $newSubscriptionButtonPressed, content: {
//                NewSubscriptionView()
                AllSubscriptionTypeView()
                
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedbackgenerator.prepare()
                                impactFeedbackgenerator.impactOccurred()
                            newSubscriptionButtonPressed.toggle()
                            
                        }) {
                            Image(systemName: "plus")
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .font(.headline)
                        .previewHeaderContent()
                        .opacity(1 - headerVisibleRatio)
                }
            }
            .toolbarBackground(.hidden)
            .statusBarHidden(scrollOffset.y > -3)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }

    @ViewBuilder
    func Header() -> some View {
        ScrollViewHeader{
            ZStack{
                Color.blue.opacity(0.9).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 10){
                    HStack(spacing: 40){
                        
                        Button(action: {
                        }) {
                            VStack{
                                Text("Dashboard")
                                    .bold()
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                                .padding(10)
//                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedbackgenerator.prepare()
                                impactFeedbackgenerator.impactOccurred()
                            newSubscriptionButtonPressed.toggle()
                            
                        }) {
                            Image(systemName: "plus")
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }.padding(.horizontal)
                        
                }
                .padding(.top,75)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
 
   



}



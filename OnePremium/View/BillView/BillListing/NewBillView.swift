//
//  NewSubscriptionServiceListView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/22.
//

import SwiftUI

enum BillFilter: String, CaseIterable {
    case Billtype = "Type"
    case All = "All"
}

enum BillTypes: String, CaseIterable {
    case Utility = "Utility bills"
    case RentandMortgage = "Rent or mortgage"
    case Carpayments = "Car payments"
    case Phoneandinternet = "Phone and internet"
    case Creditcardandloanpayments = "Credit card or loan payments"
    case Gym = "Gym memberships"
    case Insurance = "Insurance"
}

struct NewSubscriptionView: View {
    
    @Binding var selectedType: BillTypes?
    // MARK:  Parameters
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented: Bool = false
    @State private var subscriptions = [SubscriptionService]()
    @State var selectedSubscription = SubscriptionService(id: "", name: "", logoName: "", descriptionText: "", subscriptionCategory: "", subscriptionType: "")
    
    private var subscriptionsGroupedByCategory: [String: [SubscriptionService]] {
            Dictionary(grouping: subscriptions) { $0.subscriptionCategory }
        }
    private var filteredSubscriptions: [SubscriptionService] {
         if searchText.isEmpty {
             return subscriptions
         } else {
             return subscriptions.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
         }
     }
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    TextField(text: $searchText) {
                        Label("Search bills", systemImage: "magnifyingglass")
                    }
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .foregroundColor(Color.primary)
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }.padding(.horizontal)
                if selectedType == .Phoneandinternet{
                    List{
                        ForEach(subscriptionsGroupedByCategory.keys.sorted(), id: \.self) { category in
                            Section(header: Text(category)) {
                                ForEach(subscriptionsGroupedByCategory[category]!) { subscription in
                                    Button(action: {
                                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                        impactFeedbackgenerator.prepare()
                                        impactFeedbackgenerator.impactOccurred()
                                        isPresented.toggle()
                                        selectedSubscription = subscription
                                    }) {
                                        HStack{
                                            Image(subscription.logoName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            VStack(alignment: .leading) {
                                                Text(subscription.name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Text(subscription.descriptionText)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8).delay(0.3)){
                            loadData()
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresented, content: {
                SubscriptionEntryView(service: $selectedSubscription)
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
            })
            .navigationBarTitle("Add Your Bill")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func loadData() {
        guard let url = Bundle.main.url(forResource: "Subscriptions", withExtension: "json") else {
            fatalError("Failed to locate Subscriptions.json in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load Subscriptions.json from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            subscriptions = try decoder.decode([SubscriptionService].self, from: data)
        } catch {
            print("Error decoding JSON data: \(error.localizedDescription)")
        }
    }
}


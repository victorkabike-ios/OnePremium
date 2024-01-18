//
//   TypeFilterView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/30.
//

import Foundation
import SwiftUI


struct TypeFilterView: View {
    @State private var isSelected: Bool = false
    @State private var isPresentingSheet = false
    @State private var selectedType:BillTypes? = .Phoneandinternet
    let colors: [Color] = [.blue.opacity(0.4), .mint.opacity(0.4), .yellow.opacity(0.4), .green.opacity(0.4), .blue.opacity(0.4), .purple.opacity(0.4), .pink.opacity(0.4)]
    let emojis:[String] = ["💡", "🏡", "🚘","📱","💳","🏋️‍♀️","🛡️"]
    var body: some View {
            List{
                ForEach(Array(BillTypes.allCases.enumerated()), id: \.element) { index, billType in
                    Button(action: {
                        selectedType = billType
                        isPresentingSheet = true
                    }) {
                        HStack{
                            Text(emojis[index % emojis.count])
                                .font(.title)
                                .padding()
                                .background(colors[index % colors.count])
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(billType.rawValue)
                                .font(.system(size: 14))
                                .bold()
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .bold()
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    
                }
            }
            .listStyle(.grouped)
            .sheet(isPresented: $isPresentingSheet) {
                    NewSubscriptionView(selectedType: $selectedType)
                    // Add additional conditions for other bill types
            }
    }
}

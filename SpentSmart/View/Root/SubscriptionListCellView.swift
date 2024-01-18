//
//  SubscriptionListCellView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/03/11.
//

import SwiftUI

struct SubscriptionListCellView: View {
    // Creating a view model object to manage subscription service details
    @StateObject var  billViewModel = BillsViewModel()
    
    var bill: Bill
  
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()
    

    
    var body: some View {
            HStack(spacing: 20){
                Image(bill.image ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                HStack{
                    VStack(alignment: .leading){
                        Text(bill.name ?? "Unkown")
                            .foregroundColor(.primary)
                            .bold()
                        
                        Text(bill.billCycle ?? "N/A")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(billViewModel.CurrencyPrice(price: bill.amount))
                            .foregroundColor(.primary)
                            .bold()
                        Text(dateFormatter.string(from: bill.dueDate ?? Date() ))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
    }
    
}


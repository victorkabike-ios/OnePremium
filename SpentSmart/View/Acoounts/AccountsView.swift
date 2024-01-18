//
//  AccountsView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/04.
//

import Foundation
import SwiftUI
import CoreData

enum AccountName: String, CaseIterable {
    case checking = "Checking Account"
    case saving = "Savings Account"
    case Cash = "Cash Account"
    case credit = "Credit Account"
}

struct AccountsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var accountViewModel =  AccountsViewModel()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
    // Currency Formating on Price
    func CurrencyPrice(balance: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: balance)) ?? ""
        
    }
    let colors: [Color] = [.blue.opacity(0.6), .mint.opacity(0.6), .yellow.opacity(0.6), .green.opacity(0.6)]
    var body: some  View {
        VStack{
            if accountViewModel.isAccountsEmpty(in: viewContext){
                VStack(alignment: .leading,spacing: 20){
                    ForEach(Array(AccountName.allCases.enumerated()), id: \.element){ index, account in
                        HStack{
                            Image( systemName: "square.3.stack.3d.top.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(8)
                                .background(colors[index % colors.count])
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 8){
                                Text(account.rawValue)
                                    .foregroundColor(.primary)
                                    .bold()
                                
                                Text("Current Balance: \(CurrencyPrice(balance: 0))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                   
                            }
                            
                        }
                    }
                }
            }else{
                let accounts = accountViewModel.fetchAccounts(in: viewContext)
                VStack(alignment: .leading,spacing: 20){
                    ForEach(Array(accounts.enumerated()), id: \.element){ index, account in
                        HStack{
                            Image( systemName: account.image ?? "square.3.stack.3d.top.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(8)
                                .background(colors[index % colors.count])
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading,spacing: 8){
                                Text(account.accountName ?? "Unkown")
                                    .foregroundColor(.primary)
                                    .bold()
                                
                                Text("Current Balance: \(CurrencyPrice(balance:account.balance))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
            }
        }
    }
}

//
//  AllBillTypeView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/30.
//

import Foundation
import SwiftUI

struct AllSubscriptionTypeView: View{
    @State private var selectedFilter: BillFilter = .Billtype
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack( alignment: .leading){
                HStack{
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                        Text("Cancel")
                            .bold()
                            .font(.headline)
                    }
                }.padding(.horizontal)
                Text("Choose new bill")
                    .font(.system(size: 28))
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.bottom,20)
                HStack{
                    ForEach(BillFilter.allCases, id: \.self){ filter in
                        Text(filter.rawValue)
                            .foregroundColor(filter == selectedFilter ? Color.white : .primary)
                            .font(.system(size: 18))
                            .bold()
                            .frame(width: 180, height: 40)
                            .background(content: {
                                if filter == selectedFilter {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue)
                                                }
                            })
                            
                    }
                }
                .frame(width: 360, height: 40)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                if selectedFilter == .Billtype {
                    TypeFilterView()
                }
            }
            
        }
    }
}

//
//  CategoryPicker.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/23.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: SubscriptionCategory
    var body: some View {
        Picker(selection: $selectedCategory, label: Text("Subscription Category")) {
                    ForEach(SubscriptionCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
        }.pickerStyle(.wheel)
    }
}


//
//  SubscriptionPlanPicker.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/23.
//

import SwiftUI

struct SubscriptionPlanPicker: View {
    @Binding var selectedPlan: SubscriptionPlans
    var body: some View {
        Picker(selection: $selectedPlan, label: Text("Subscription Plans")) {
                    ForEach(SubscriptionPlans.allCases, id: \.self) { plan in
                        Text(plan.rawValue)
                    }
        }.pickerStyle(.wheel)
    }
}


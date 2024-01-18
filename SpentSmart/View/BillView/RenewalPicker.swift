//
//  RenewalPicker.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/23.
//


import SwiftUI

struct RenewalPicker: View {
    @Binding var selectedRenewalTime: RenewalCycle
    @State var isCyclePressed:Bool = false
    var body: some View {
        Picker(selection: $selectedRenewalTime) {
            ForEach(RenewalCycle.allCases, id: \.self){ cycle in
                Button(action: {selectedRenewalTime = cycle}) {
                    Text(cycle.rawValue)
                        .foregroundColor(.primary)
                        .font(.system(size: 14))
                        
                }
                
            }
        } label: {
            Text("Select Renewal Cycle")
        }.pickerStyle(.wheel)

        
    }
}


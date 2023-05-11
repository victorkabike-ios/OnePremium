//
//  TransactionDatePicker.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/23.
//

import SwiftUI

struct TransactionDatePicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        DatePicker(selection: $selectedDate, displayedComponents: .date) {
            Text("Select a date")
        }.datePickerStyle(.graphical)
    }
}

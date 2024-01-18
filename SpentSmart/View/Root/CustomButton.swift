//
//  CustomButton.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/17.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let amount: String
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment:.leading){
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(amount)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .bold()
                }
               
            }
        }
    }
    
}

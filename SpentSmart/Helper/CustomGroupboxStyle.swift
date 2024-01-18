//
//  CustomGroupboxStyle.swift
//  OnePremium
//
//  Created by victor kabike on 2023/03/16.
//

import Foundation
import SwiftUI
struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 16)
            configuration.content
                .padding(16)
                .background(Color(UIColor.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4)
        }
    }
}



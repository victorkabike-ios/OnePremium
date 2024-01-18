//
//  CustomBackgroundModifier.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/11.
//

import SwiftUI

struct CustomModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color.white)
            }
    }
}

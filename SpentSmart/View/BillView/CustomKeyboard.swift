//
//  CustomKeyboard.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/23.
//

import Foundation
import SwiftUI

struct CurrencyKeyboard: View {
    @Binding var text: String
    @Binding var isEditing: Bool


    var body: some View {
        VStack(spacing: 40){
            Spacer()
            LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 30), count: 3),spacing: 10) {
                ForEach(1...9, id: \.self){ index in
                    KeyboardButtonView(.text("\(index)")){
                        text.append("\(index)")
                    }.disabled(text.count > 8)
                }
                // Other button with Zero at the Center
                KeyboardButtonView(.text(".")){
                    text.append(".")
                }
                .disabled(text.contains("."))
                KeyboardButtonView(.text("0")){
                    text.append("0")
                }
                KeyboardButtonView(.image("delete.backward")){
                    if !text.isEmpty {
                        text.removeLast()
                    }
                }
            }
            Button(action: {isEditing = false}) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }.padding(.horizontal,40)
        }
    }
    // Keyboard button
    @ViewBuilder
    func KeyboardButtonView(_ value:KeyboardValue, onTap: @escaping () -> ()) -> some View{
        Button(action:onTap) {
            ZStack{
                switch value {
                case .text(let string):
                    Text(string)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                case .image(let image):
                    Image(systemName: image)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)

        }
    }
    
    // Enum Keyboard
    enum KeyboardValue {
        case text(String)
        case image(String)
    }
}

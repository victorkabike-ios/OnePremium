//
//  NewSubscriptionsRowView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/23.
//
import SwiftUI

struct NewSubscriptionsRowView: View {
    let service: SubscriptionService
    
    var body: some View {
        GroupBox{
            HStack(spacing: 10){
                Image(service.logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading){
                    Text(service.name)
                        .foregroundColor(.primary)
                    Text(service.descriptionText)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
            }
        }
        
    }
}


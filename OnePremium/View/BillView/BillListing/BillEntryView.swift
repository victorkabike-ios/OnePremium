//
//  SubscriptionEntryView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/24.
//

import SwiftUI

struct SubscriptionEntryView: View {
    
    
    // Creating a view model object to manage subscription service details
    @ObservedObject var  billViewModel = BillsViewModel()
    
    // The subscription service to be added/edited
    @Binding var service: SubscriptionService
    
    // Indicates whether the keyboard should be displayed
    @FocusState var showKeyboard: Bool
    
    // Indicates whether the subscription entry view should be displayed
    @State var showSaveAlertMessage: Bool = false
    // Used to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    // Indicates whether the Save button should be displayed
    @State var showSaveButton:Bool = false
    @State private var isPickerPresented = false
    
    @State  var isShowingAlert = false
    
    @State var  amount:String = ""
    @State private var isEditing = true
    
    @State private var notes: String = ""
    @State private var addNote = false
    
    @State private var accountName: String = "Cash Account"
    @State private var showAccountPicker = false
    
    @State private var showDatePicker = false
    @State private var intialPaymentDate =  Date()
    
    @State private var isRecurringPayment: Bool = false
    @State private var notification: Bool = false
    
    @State private var showRenewalCyclePicker: Bool = false
    @State private var selectedCycle = RenewalCycle.weekly
    var body: some View {
        ZStack{
            Color.blue.opacity(0.06).edgesIgnoringSafeArea(.all)
            VStack{
                VStack(alignment:.center, spacing: 20){
                    // Displaying the service logo
                    Image(service.logoName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    Text(billViewModel.CurrencyFormat(string: amount))
                        .onTapGesture {
                            isEditing = true
                        }
                        .font(.system(size: 48))
                        .foregroundColor(.primary)
                        .bold()
                    VStack(alignment: .leading){
                        if addNote {
                            TextField(service.descriptionText, text: $notes)
                                .padding(.horizontal)
                                .padding(.vertical)
                                .background(Color.white)
                                .clipShape(RoundedCorner(radius: 10, corners: [.allCorners]))
                                .transition(.move(edge: .bottom))
                        }else{
                            Button(action: {addNote.toggle()}) {
                                Label("Add Note", systemImage: "plus")
                                    .padding(.horizontal,20)
                                    .padding(.vertical,10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    
                }
                .padding(.vertical,20)
                .padding(.horizontal)
                VStack{
                    if isEditing {
                        CurrencyKeyboard(text: $amount,isEditing: $isEditing)
                            .transition(.move(edge: .bottom))
                    }else{
                        BillFormView()
                            .transition(.push(from: .leading))
                    }
                }.animation(.default, value: isEditing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder func BillFormView() -> some View{
        ScrollView{
            VStack(spacing: 25){
                VStack{
                    HStack{
                        VStack(alignment:.leading,spacing: 5){
                            Text("Account")
                                .font(.subheadline)
                                .bold()
                            Text(AccountName.checking.rawValue)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        Spacer()
                        Button(action: {
                            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedbackgenerator.prepare()
                                impactFeedbackgenerator.impactOccurred()
                            showAccountPicker.toggle()
                            
                        }) {
                            Image(systemName:showAccountPicker ? "chevron.up" : "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 15, corners: [.allCorners]))
                VStack(alignment: .leading,spacing: 18){
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                        VStack(alignment:.leading,spacing: 5){
                            Text("First Payment Date")
                                .font(.subheadline)
                                .bold()
                            Text(intialPaymentDate,style: .date)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        Spacer()
                        Button(action: {
                            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedbackgenerator.prepare()
                                impactFeedbackgenerator.impactOccurred()
                            showDatePicker.toggle()
                            
                        }) {
                            Image(systemName: showDatePicker ? "chevron.up" : "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    
                    Divider()
                    if showDatePicker {
                        TransactionDatePicker(selectedDate: $intialPaymentDate)
                            .transition(.move(edge: .top))
                    }
                    Toggle(isOn: $isRecurringPayment) {
                        VStack(alignment:.leading,spacing: 5){
                            Text("Recurring Payment")
                                .font(.subheadline)
                                .bold()
                            Text("Turn on to automatically renew this subscription")
                                .foregroundColor(.secondary)
                                .font(.caption2)
                            
                        }
                    }
                    if isRecurringPayment{
                        HStack{
                            Image(systemName: "clock.arrow.2.circlepath")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(Circle())
                            VStack(alignment:.leading,spacing: 5){
                                Text("Renewal Cycle")
                                    .font(.subheadline)
                                    .bold()
                                Text(selectedCycle.rawValue)
                                    .foregroundColor(.secondary)
                                    .font(.caption2)
                                
                            }
                            Spacer()
                            Button(action: {
                                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                    impactFeedbackgenerator.prepare()
                                    impactFeedbackgenerator.impactOccurred()
                                showRenewalCyclePicker.toggle()
                                
                            }) {
                                Image(systemName: showRenewalCyclePicker ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        Divider()
                        if showRenewalCyclePicker {
                            RenewalPicker(selectedRenewalTime: $selectedCycle)
                                .transition(.move(edge: .top))
                        }
                    }
                    Toggle(isOn: $notification) {
                        VStack(alignment:.leading,spacing: 5){
                            Text("Notification")
                                .font(.subheadline)
                                .bold()
                            Text("Notify me when it’s time to renew my subscription")
                                .foregroundColor(.secondary)
                                .font(.caption2)
                            
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 18, corners: [.allCorners]))
                Spacer()
                Button(action: {
                    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    billViewModel.addNewRecurringBill(name: service.name, amount: amount, category:BillTypes.Phoneandinternet.rawValue, notes: notes, startDate: intialPaymentDate, billCycle: selectedCycle.rawValue , image: service.logoName)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }.padding(.horizontal)
        }
    }
    
}



struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}






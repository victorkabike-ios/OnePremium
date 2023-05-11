
import SwiftUI
import CoreData

struct MonthlySpendingChartView: View {
    let context: NSManagedObjectContext
    @StateObject var  billViewModel = BillsViewModel()

    
    var body: some View {
        let spending = billViewModel.monthlySpending(context: context)
        let lastSixMonths = spending.suffix(6)
        
        VStack {
            Text("Last 6 Months Spending")
                .font(.largeTitle)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                let maxAmount = lastSixMonths.map { $0.amount }.max() ?? 0
                let xStep = width / CGFloat(lastSixMonths.count)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height))
                    
                    for (index, data) in lastSixMonths.enumerated() {
                        let x = CGFloat(index) * xStep
                        let y = height - (height * CGFloat(data.amount / maxAmount))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.5))
                
                Path { path in
                    for (index, data) in lastSixMonths.enumerated() {
                        let x = CGFloat(index) * xStep
                        let y = height - (height * CGFloat(data.amount / maxAmount))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .frame(height: 200)
            
            HStack {
                ForEach(lastSixMonths, id: \.month) { data in
                    VStack {
                        Text("\(data.amount, specifier: "%.2f")")
                            .font(.caption)
                        Spacer()
                        Text(data.month)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
    }
}

//
//  AnalyticsSectionView.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/04.
//
//
//import SwiftUI
//import Charts
//
//struct AnalyticsSectionView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    //State Data for Chart
//    // Creating a view model object to manage subscription service details
//    @StateObject var  billViewModel = BillsViewModel()
//    @State private var monthlySpending: [MonthlySpending] = []
//    
//    
//    
//    
//    var body: some View {
//        VStack(alignment: .leading,spacing: 10){
//            Chart{
//                ForEach(monthlySpending,id: \.month){ spending in
//                    LineMark(x:.value("Category",spending.month) ,
//                             y: .value("Spenting", spending.spending)
//                    )
//                    .interpolationMethod(.catmullRom)
//                    .foregroundStyle(Color.blue)
//                    .symbol(){
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10)
//                    }
//                   AreaMark(
//                        x: .value("Category",spending.month),
//                        y: .value("Spenting", spending.spending)
//                    )
//                    .interpolationMethod(.catmullRom)
//                    .foregroundStyle(Color.blue.opacity(0.6).gradient)
//                }
//            }
//            .onAppear{
//                subscriptionViewModel.objectWillChange.send()
//                monthlySpending = subscriptionViewModel.fetchMonthlySpending(context: viewContext)
//                for(index,_) in monthlySpending.enumerated(){
//                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05){
//                        withAnimation(.easeInOut(duration: 0.8).delay(0.3)){
//                            monthlySpending[index].animate = true
//                        }
//                    }
//                }
//            }
//            .frame(height: 200)
//           
//        }
//    }
//}
//

//
//  CategorySpending.swift
//  OnePremium
//
//  Created by victor kabike on 2023/04/04.
//

import Foundation
// define a struct to hold the category and total spending for that category
struct CategorySpending {
    let category: String
    let totalSpending: Double
}
struct MonthlySpending: Hashable{
    let  month: String
    let spending: Double
    var animate: Bool = false
    
}

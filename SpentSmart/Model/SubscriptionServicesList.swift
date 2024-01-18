//
//  SubscriptionServicesList.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/21.
//

import Foundation


struct SubscriptionService:  Codable, Identifiable {
    let id: String
    let name: String
    let logoName: String
    let descriptionText: String
    let subscriptionCategory: String
    let subscriptionType: String
}

// List of All Subscription Services Categories
enum SubscriptionCategory: String, CaseIterable, Comparable, Codable {
    static func < (lhs: SubscriptionCategory, rhs: SubscriptionCategory) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    case book = "Book"
    case Business = "Business"
    case DeveloperTools = "Developer Tools"
    case Entertainment = "Entertainment"
    case Finance = " Finance"
    case education = "online learning platform"
    case news = "News"
    case magazines = "Magazines"
    case HealthAndFitness = "Health & Fitness"
    case productivity = "Productivity"
    case FoodAndDrink = "Food & Drink"
    case GraphicsDesign = "Graphics & Design"
    case kids = "Kids"
    case lifestyle = "Lifestyle"
    case Music = "Music"
    case PhotoAndVideo = "Photo & Video"
    case Shopping = "Shopping"
    case SocialNetworking = "Social Networking"
    case Sports = "Sports"
    case Travel = "Travel"
    case Utilities = "Utilities"
    case weather = "Weather"
}

enum SubscriptionPlans: String, CaseIterable, Codable {
    case Freetrial = "Free trial"
    case Basic = "Basic"
    case Premium = "Premium"
    case Family = "Family"
    case Student = "Student"
}
/// List of Subscription Types
enum RenewalCycle: String, CaseIterable, Codable {
    case weekly = "weekly"
    case biWeekky = "bi-weekly"
    case monthly = "monthly"
    case quarterly = "quarterly"
    case sixMonthly = "6 months"
    case yearly = "yearly"
}

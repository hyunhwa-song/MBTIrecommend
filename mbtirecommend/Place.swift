//
//  Place.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/17/25.
//

import Foundation

// MARK: — Place 모델
struct Place: Codable {
    let mbtiTypes: [String]
    let category: PlaceCategory
    let name: String
    let summary: String         // JSON의 "description"
    let reason: String
    let imageURL: String
    let webURL: URL?
    let address: String?
    let phoneNumber: String?
    let businessHours: String?
    let priceRange: String?
    let tags: [String]
    let coordinates: Coordinates

    struct Coordinates: Codable {
        let latitude: Double
        let longitude: Double
    }

    private enum CodingKeys: String, CodingKey {
        case mbtiTypes
        case category
        case name
        case summary      = "description"
        case reason
        case imageURL
        case webURL
        case address
        case phoneNumber
        case businessHours
        case priceRange
        case tags
        case coordinates
    }
}

enum PlaceCategory: String, CaseIterable, Codable {
    case cafe, restaurant, activity, culture, travel

    var title: String {
        switch self {
        case .cafe:       return "☕ 카페"
        case .restaurant: return "🍽 음식점"
        case .activity:   return "🎡 놀거리"
        case .culture:    return "🏛 전시·문화"
        case .travel:     return "🧳 여행지"
        }
    }
    var iconName: String {
        switch self {
        case .cafe:       return "cup.and.saucer.fill"
        case .restaurant: return "fork.knife"
        case .activity:   return "figure.walk"
        case .culture:    return "paintpalette"
        case .travel:     return "airplane"
        }
    }
}

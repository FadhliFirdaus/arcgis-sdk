//
//  CardModel.swift
//  ArcGIS SDK
//
//  Created by Fadhli Firdaus on 21/05/2024.
//

import Foundation
import SwiftUI

struct CardItem {
    let itemName:String
    let itemValue:String
    let metric:String
    let icon:String
    let color:Color
    
    static let mockCard = CardItem(itemName: "bicycle", itemValue: "KM", metric: "12", icon: "bicycle", color: Color.yellow)
    
    static let mockCardItems: [CardItem] = [
        CardItem(itemName: "flame", itemValue: "Calories", metric: "250", icon: "flame", color: Color.red),
        CardItem(itemName: "heart", itemValue: "BPM", metric: "72", icon: "heart", color: Color.pink),
        CardItem(itemName: "bed.double", itemValue: "Hours", metric: "8", icon: "bed.double", color: Color.blue),
        CardItem(itemName: "leaf", itemValue: "Steps", metric: "1000", icon: "leaf", color: Color.green)
    ]
}

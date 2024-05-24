//
//  MapMode.swift
//  ArcGIS SDK
//
//  Created by Fadhli Firdaus on 23/05/2024.
//

import Foundation
import ArcGIS

enum MapMode: String, CaseIterable {
    case Tracking
    case Searching
    case Basemap
    
    func next() -> MapMode {
        guard let currentIndex = MapMode.allCases.firstIndex(of: self) else {
            return self // If current mode is not found, return self
        }
        let nextIndex = (currentIndex + 1) % MapMode.allCases.count
        return MapMode.allCases[nextIndex]
    }
}

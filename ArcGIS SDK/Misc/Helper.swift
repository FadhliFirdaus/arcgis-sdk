    //
    //  Helper.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 21/05/2024.
    //

import Foundation
import UIKit
import SwiftUI

let sw = UIScreen.main.bounds.size.width
let sh = UIScreen.main.bounds.size.height
let sz = UIScreen.main.bounds.size

struct CustomFontModifier: ViewModifier {
    var fontName: String
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
    }
}

extension View {
    func redBackground() -> some View {
        self.background(Color.red)
    }
    
    func yellowBackground() -> some View {
        self.background(Color.yellow)
    }
    
    func blueBackground() -> some View {
        self.background(Color.blue)
    }
}

func formatSecondsToHMS(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60
    
    return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
}

func randomGaussian(mean: Double, standardDeviation: Double) -> Double {
    let u1 = Double(arc4random()) / Double(UINT32_MAX)
    let u2 = Double(arc4random()) / Double(UINT32_MAX)
    let z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * Double.pi * u2)
    return z0 * standardDeviation + mean
}

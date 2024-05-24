    //
    //  ArcGIS_SDKApp.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 20/05/2024.
    //

import SwiftUI
import ArcGIS

@main
struct ArcGIS_SDKApp: App {
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
        }
    }
    
    init() {
        ArcGISEnvironment.apiKey = APIKey(APIManager.arcGisAPIKEY)
    }
}

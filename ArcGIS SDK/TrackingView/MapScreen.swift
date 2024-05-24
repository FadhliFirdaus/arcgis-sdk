    //
    //  NewMapScreen.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 23/05/2024.
    //

import SwiftUI
import ArcGIS
import ArcGISToolkit

struct MapScreen: View {
    
    @StateObject var model = Model()
    @StateObject var loc = LocationManager.shared

    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                MapViewReader { mapProxy in
                    let mapView = MapView(map: model.map, graphicsOverlays: [model.searchResultsOverlay])
                    updateMapView(model: model, for: model.currentMode, mapView: mapView, mapProxy: mapProxy, geoProxy:geometryProxy)
                }
                VStack{
                    HStack {
                        Spacer()
                        Button(action: {
                            model.goToNextMode()
                        }, label: {
                            Text("\(model.currentMode.rawValue)")
                                .buttonStyle(BorderedButtonStyle())
                        })
                        .padding(.trailing, 24)
                        .padding(.top, 30)
                    }
                    Spacer()
                }
                .frame(width: sw, height: sh, alignment: .center)
                .onAppear(perform: {
                    loc.requestLocation()
                })
            }
        }
    }
    
    @ViewBuilder
    func updateMapView(model: MapScreen.Model, for mode: MapMode, mapView: MapView, mapProxy: MapViewProxy, geoProxy:GeometryProxy) -> some View {
        switch mode {
        case .Tracking:
            TrackingView(model: model, loc: loc, mapProxy: mapProxy)
        case .Searching:
            SearchWithGeocodeView()
        case .Basemap:
            mapView
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Toggle(isOn: $model.isShowingBasemapGallery) {
                            Label("Basemap Gallery", systemImage: "map")
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if model.isShowingBasemapGallery {
                        BasemapGallery(geoModel: model.map)
                            .style(.automatic())
                            .frame(maxWidth: geoProxy.size.width / 3)
                            .esriBorder()
                            .padding()
                    }
                }
            VStack {
                HStack{
                    Button {
                        model.isShowingBasemapGallery.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48) // Adjust the size of the circle directly
                            Image(systemName: "square.stack.3d.up")
                                .resizable()
                                .scaledToFit() // Ensures the image retains its aspect ratio
                                .frame(width: 28, height: 28) // Adjust the size of the image
                        }
                        .frame(width: 48, height: 48) // Frame size of the ZStack to match the Circle's size
                        
                    }
                    Spacer()
                }
                .padding(30)
            }
            .frame(width: sw, height: sh, alignment: .top)
        }
    }
}




extension MapScreen {
    class Model: ObservableObject {
        let map: Map =  {
            let map = Map(basemapStyle: .arcGISImagery)
            map.initialViewpoint = Viewpoint(latitude: 3.1728, longitude: 101.7197, scale: 1_000)
            return map
        }()
        let graphicsOverlay = GraphicsOverlay()
        let searchResultsOverlay = GraphicsOverlay()

        var lastUpdateTime: Date?
        var currentMap = "Default"
        var isShowingBasemapGallery = false
        var searchText = "Current search"
        var searchViewpoint: Viewpoint? = Viewpoint(
            center: Point(
                x: -93.258133,
                y: 44.986656,
                spatialReference: .wgs84
            ),
            scale: 1e6
        )
        var isGeoViewNavigating = false
        var geoViewExtent: Envelope?
        var queryCenter: Point?
        var identifyScreenPoint: CGPoint?
        var identifyTapLocation: Point?
        var calloutPlacement: CalloutPlacement?
        @ObservedObject var locatorDataSource = LocatorSearchSource(
            name: "My Locator",
            maximumResults: 10,
            maximumSuggestions: 5
        )
        
        @Published var currentBasemap:Basemap.Style = .arcGISImagery
        @Published var userLat = 0.0
        @Published var userLong = 0.0
        @Published var userDistanceInMeters = 0.0
        @Published var userTimeInSeconds = 0.0
        @Published var isRunning = false
        @Published var currentMode:MapMode = .Tracking
        @Published var scale = 1500.0
        var timer:Timer?
        
        func getUserSpeed() -> String? {
            guard userTimeInSeconds > 0 else {
                return nil
            }
            let speed = userDistanceInMeters / userTimeInSeconds
            let formattedSpeed = String(format: "%.2f", speed)
            return formattedSpeed
        }
        
        
        func getUserPace() -> String? {
            guard userDistanceInMeters != 0 else {
                return nil
            }
            let paceSecondsPerMeter = userTimeInSeconds / userDistanceInMeters
            let paceSecondsPerKm = paceSecondsPerMeter * 1000.0
            let paceMinutesPerKm = paceSecondsPerKm / 60.0
            let formattedPace = String(format: "%.2f", paceMinutesPerKm)
            return formattedPace
        }
        
        func getDistanceInKM() -> String? {
            let formattedDistance = String(format: "%.3f", userDistanceInMeters / 1000)
            return formattedDistance
        }
        
        func userTimeInHMS() -> String {
            let hours = Int(userTimeInSeconds) / 3600
            let minutes = Int(userTimeInSeconds) / 60 % 60
            let seconds = Int(userTimeInSeconds) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        func timerFunction() {
            isRunning.toggle()
            if isRunning {
                if let timer = timer {
                    timer.invalidate()
                    self.timer = nil
                } else {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        self.userTimeInSeconds += 0.1
                        let normalSpeed = 1.4
                        let variation = randomGaussian(mean: 0.0, standardDeviation: 0.2)
                        let randomSpeed = normalSpeed + variation
                        let adjustedSpeed = max(0, randomSpeed)
                        let distance = adjustedSpeed * 0.1
                        self.userDistanceInMeters += distance

                    })
                }
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
        
        func goToNextMode() {
            currentMode = currentMode.next()
        }
        
        func returnNewBasemap(mapString:String) -> Basemap.Style {
            let basemapOptions = ["Default", "Streets", "Nova"]
            if(mapString == basemapOptions[0]){
                return .arcGISImagery
            } else if (mapString == basemapOptions[1]){
                return .arcGISStreets
            } else if (mapString == basemapOptions[2]){
                return .arcGISNova
            }
            return .arcGISImagery
        }
        
        func getNewViewpoint() -> Viewpoint {
            return Viewpoint(latitude: userLat, longitude: userLong, scale: scale)
        }
    }
    
}

#Preview {
    MapScreen()
}

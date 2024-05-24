    //
    //  TrackingView.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 23/05/2024.
    //

import SwiftUI
import ArcGIS

struct TrackingView: View {
    
    @ObservedObject var model: MapScreen.Model
    @StateObject var loc:LocationManager
    var mapProxy:MapViewProxy
    
    @StateObject var gm = GraphicManager.shared
    
    @State private var map: Map = {
        let map = Map(basemapStyle: .arcGISTopographic)
        map.initialViewpoint = Viewpoint(latitude: 34.02700, longitude: -118.80500, scale: 12_000)
        return map
    }()
    
    var body: some View {
        MapView(map: map, graphicsOverlays: [gm.graphicsOverlay])
            .task(id: "\(model.userLat)-\(model.userLong)") {
                if(model.isRunning){
                    gm.addPointGraphics(point: Point(latitude: model.userLat, longitude: model.userLong))
                    gm.continuousTrackingPoints.append(Point(latitude: model.userLat, longitude: model.userLong))
                    gm.addLineGraphic(points: gm.continuousTrackingPoints)
                    await mapProxy.setViewpointCenter(Point(latitude: model.userLat, longitude: model.userLong), scale: 1_500)
                }
            }
            .onChange(of: loc.currentUserLocation?.coordinate.latitude ?? 0.0) { oldValue, newValue in
                model.userLat = newValue
            }
            .onChange(of: loc.currentUserLocation?.coordinate.longitude ?? 0.0) { oldValue, newValue in
                model.userLong = newValue
            }
            .overlay {
                VStack{
                    Spacer()
                        .frame(height: sh/2)
                    TrackingCards(cards: [
                        CardItem(itemName: "Distance", itemValue: model.getDistanceInKM() ?? "", metric: "KM", icon: "scribble.variable", color: Color.orange),
                        CardItem(itemName: "Time", itemValue: model.userTimeInHMS(), metric: "", icon: "timer", color: Color.indigo),
                        CardItem(itemName: "Speed", itemValue: String(model.getUserSpeed() ?? "0.00"), metric: "M/s", icon: "figure.run", color: Color.red),
                        CardItem(itemName: "Pace", itemValue: String(model.getUserPace() ?? "0.00"), metric: "m/KM", icon: "figure", color: Color.brown)
                    ])
                    .overlay {
                        Button {
                            model.timerFunction()
                        } label: {
                            ZStack{
                                Circle()
                                    .frame(width: sw/8, height: sw/8, alignment: .center)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                Image(systemName: model.isRunning ? "stop" : "play")
                                    .resizable()
                                    .frame(width: sw/15, height: sw/15, alignment: .center)
                                    .foregroundColor(model.isRunning ? .green : .red)
                                    .offset(x: model.isRunning ? 0:3.5)
                            }
                        }
                    }
                    VStack{
                        Text("lat : \(loc.currentUserLocation?.coordinate.latitude ?? 0.0)")
                            .foregroundColor(.black)
                            .background(.white)
                        Text("long : \(loc.currentUserLocation?.coordinate.longitude ?? 0.0)")
                            .foregroundColor(.black)
                            .background(.white)
                    }
                }
            }
    }
}

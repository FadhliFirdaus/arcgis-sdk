    //
    //  GraphicManager.swift
    //  ArcGIS SDK
    //
    //  Created by Fadhli Firdaus on 23/05/2024.
    //

import Foundation
import CoreLocation
import ArcGIS

class GraphicManager: ObservableObject {
    
    static let shared = GraphicManager()
    
    @Published var graphicsOverlay: GraphicsOverlay = GraphicsOverlay()
    
    @Published var continuousTrackingPoints:[Point] = [] {
        didSet {
            if(continuousTrackingPoints.count > 1){
                let c = continuousTrackingPoints.count
                addLineGraphic(points: [continuousTrackingPoints[c - 1], continuousTrackingPoints[c - 2]])
            }
        }
    }
    
    @Published var userGraphics:[ArcGIS.Graphic] = [] {
        didSet {
            graphicsOverlay.removeAllGraphics()
            for graphic in userGraphics {
                graphicsOverlay.addGraphic(graphic)
            }
        }
    }
    
    private init(){
        testGraphics()
    }
    
    func testGraphics(){
        addPointGraphics(point: Point(latitude: 3.1774, longitude: 101.7476))
        
        addLineGraphic(points: [
            Point(latitude: 3.1774, longitude: 101.7476),
            Point(latitude: 3.1774, longitude: 101.7476),
            Point(latitude: 3.1720, longitude: 101.7423),
            Point(latitude: 3.1730, longitude: 101.7434),
            Point(latitude: 3.1740, longitude: 101.741231),
            Point(latitude: 3.1750, longitude: 101.7879),
        ])
        
        addPolygonGraphic(points: [
            Point(latitude: 3.1774, longitude: 101.7476),
            Point(latitude: 3.1774, longitude: 101.7476),
            Point(latitude: 3.1720, longitude: 101.7423),
            Point(latitude: 3.1730, longitude: 101.7434),
            Point(latitude: 3.1740, longitude: 101.741231),
            Point(latitude: 3.1750, longitude: 101.7879),
        ])
    }
    
    func addLineGraphic(points:[Point]){
        let polylineSymbol = SimpleLineSymbol(style: .shortDashDot, color: .red, width: 3.0)
        let polylineGraphic = Graphic(geometry: Polyline(points: points), symbol: polylineSymbol)
        graphicsOverlay.addGraphic(polylineGraphic)
    }
    
    func addPointGraphics(point:Point){
        let pointSymbol = SimpleMarkerSymbol(style: .circle, color: .orange, size: 10.0)
        pointSymbol.outline = SimpleLineSymbol(style: .solid, color: .blue, width: 2.0)
        let pointGraphic = Graphic(geometry: point, symbol: pointSymbol)
        graphicsOverlay.addGraphic(pointGraphic)
    }
    
    func addPolygonGraphic(points:[Point]){
        let polygon = Polygon(points:points)
        let polygonSymbol = SimpleFillSymbol(style: .solid, color: .white.withAlphaComponent(0.6), outline: SimpleLineSymbol(style: .solid, color: .black, width: 3.0))
        let polygonGraphic = Graphic(geometry: polygon, symbol: polygonSymbol)
        graphicsOverlay.addGraphic(polygonGraphic)
    }
    
}


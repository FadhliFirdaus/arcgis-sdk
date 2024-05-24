













import SwiftUI
import ArcGIS
import ArcGISToolkit

struct SearchWithGeocodeView: View {
    
    
    @State private var viewpoint: Viewpoint? = Viewpoint(
        center: Point(
            x: -93.258133,
            y: 44.986656,
            spatialReference: .wgs84
        ),
        scale: 1e6
    )
    
    
    
    @State private var isGeoViewNavigating = false
    
    
    
    @State private var geoViewExtent: Envelope?
    
    
    @State private var queryCenter: Point?
    
    
    @State private var identifyScreenPoint: CGPoint?
    
    
    @State private var identifyTapLocation: Point?
    
    
    @State private var calloutPlacement: CalloutPlacement?
    
    
    @ObservedObject private var locatorDataSource = LocatorSearchSource(
        name: "My Locator",
        maximumResults: 10,
        maximumSuggestions: 5
    )
    
    
    @StateObject private var model = Model()
    
    var body: some View {
        MapViewReader { proxy in
            MapView(
                map: model.map,
                viewpoint: viewpoint,
                graphicsOverlays: [model.searchResultsOverlay]
            )
            .onSingleTapGesture { screenPoint, tapLocation in
                identifyScreenPoint = screenPoint
                identifyTapLocation = tapLocation
            }
            .onNavigatingChanged { isGeoViewNavigating = $0 }
            .onViewpointChanged(kind: .centerAndScale) {
                queryCenter = $0.targetGeometry.extent.center
            }
            .onVisibleAreaChanged { newVisibleArea in
                geoViewExtent = newVisibleArea.extent
            }
            .callout(placement: $calloutPlacement.animation()) { placement in
                Text(placement.geoElement?.attributes["Match_addr"] as? String ?? "Unknown Address")
                    .padding()
            }
            .task(id: identifyScreenPoint) {
                guard let screenPoint = identifyScreenPoint,
                      
                        let identifyResult = try? await proxy.identify(
                            on: model.searchResultsOverlay,
                            screenPoint: screenPoint,
                            tolerance: 10
                        )
                else {
                    return
                }
                
                calloutPlacement = identifyResult.graphics.first.flatMap { graphic in
                    CalloutPlacement.geoElement(graphic, tapLocation: identifyTapLocation)
                }
                identifyScreenPoint = nil
                identifyTapLocation = nil
            }
            .overlay {
                VStack{
                    Spacer()
                        .frame(height: 45)
                    SearchView(
                        sources: [locatorDataSource],
                        viewpoint: $viewpoint
                    )
                    .resultsOverlay(model.searchResultsOverlay)
                    .queryCenter($queryCenter)
                    .geoViewExtent($geoViewExtent)
                    .isGeoViewNavigating($isGeoViewNavigating)
                    .onQueryChanged { query in
                        if query.isEmpty {
                            calloutPlacement = nil
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

private extension SearchWithGeocodeView {
    
    
    class Model: ObservableObject {
        
        let map = Map(basemapStyle: .arcGISImagery)
        
        
        
        let searchResultsOverlay = GraphicsOverlay()
    }
}

#Preview {
    SearchWithGeocodeView()
}

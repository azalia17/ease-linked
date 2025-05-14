//
//  DetailRouteView.swift
//  BSDLink
//
//  Created by Brayen Fredgin Cahyadi on 04/04/25.
//

import SwiftUI
import MapKit

struct DetailRouteView: View {
    let route: Route
    var cameraPosition: MapCameraPosition = .region(.init(center: .init(latitude: -6.305968, longitude: 106.672272), latitudinalMeters: 13000, longitudinalMeters: 13000))
    
    let locationManager = CLLocationManager()
    @State private var routePolylines: [MKPolyline] = []
    @State private var startingPoint: String = ""
    @State private var destinationPoint: String = ""
    
    @State private var startingCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State private var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State private var destinationCoordiante: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @State private var showResultRoute = false
    
    @State private var isSearch: Bool = false
    @State private var showTimePicker: Bool = false
    @State private var showPopover: Bool = false
    @State private var timePicked = Date()
    @State private var isTimePicked: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Map(initialPosition: cameraPosition) {
                    Marker("Halte A", systemImage: "bus", coordinate: .bbb)
                        .tint(.orange.gradient)
                    
                    Marker("Halte B", systemImage: "bus", coordinate: .ccc)
                        .tint(.orange.gradient)
                    
                    Annotation("Istiqlal", coordinate: .istiqlal, anchor: .bottom) {
                        Image(systemName: "moon.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .padding(7)
                            .background(.orange.gradient, in: .circle)
                    }
                    
                }
                .ignoresSafeArea(.all)
                .navigationTitle(route.name)
                
                VStack {
                    DetailSheet(route: route)
                }
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom))
            }
        }
        
    }
}


struct DetailSheet: View {
    @State private var offsetY: CGFloat = 500 // Default height (collapsed)
    @State private var screenHeight: CGFloat = 0 // Store screen height
    let route: Route
    
    var body: some View {
        GeometryReader { geometry in
            let fullHeight = geometry.size.height
            let minHeight: CGFloat = fullHeight * 0.2 // Minimum collapsed height (10pt)
            let midHeight = fullHeight * 0.6 // 80% of the screen
            let maxHeight = fullHeight // Fully expanded
            
            RouteDetail(route: Route(id: route.id, name: route.name, routeNumber: route.routeNumber, busStops: route.busStops, bus: route.bus, schedule: route.schedule, note: route.note, colorName: route.colorName))
                .frame(height: max(minHeight, min(maxHeight, fullHeight - offsetY)))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = offsetY + gesture.translation.height
                            if newOffset >= 0 && newOffset <= fullHeight - minHeight {
                                offsetY = newOffset
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                let threshold = (fullHeight - midHeight) / 2
                                
                                if offsetY > fullHeight - midHeight + threshold {
                                    offsetY = fullHeight - minHeight // Snap to 10pt height
                                } else if offsetY > threshold {
                                    offsetY = fullHeight - midHeight // Snap to 80% height
                                } else {
                                    offsetY = 0 // Fully expanded
                                }
                            }
                        }
                )
                .onAppear {
                    screenHeight = minHeight
                    offsetY = fullHeight - midHeight // Start at 80% height
                }
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom))
        }
    }
}




//#Preview {
//    DetailRouteView(route: Route.all[0])
//}

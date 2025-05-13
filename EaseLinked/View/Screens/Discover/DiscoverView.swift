//
//  DiscoverScreen.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI
import MapKit

struct DiscoverView: View {
    @StateObject var discoverViewModel: DiscoverViewModel
    
    var cameraPosition: MapCameraPosition = .region(.init(center: .init(latitude: -6.305968, longitude: 106.672272), latitudinalMeters: 13000, longitudinalMeters: 13000))
    let locationManager = CLLocationManager()
    
    @State private var selectedDetent: PresentationDetent = .height(100)
    
    @Environment(\.verticalSizeClass) private var sizeClass
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(initialPosition: cameraPosition) {
                UserAnnotation().tint(.blue)
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            .mapStyle(.standard(elevation: .realistic))
            
            
            
            switch discoverViewModel.viewState {
            case .initial:
                SearchCard(
                    searchHandler: {},
                    swapHandler: {},
                    resetResultsCompletion: {},
                    startingPoint: $discoverViewModel.startingPoint,
                    destinationPoint: $discoverViewModel.destinationPoint,
                    activeTextField: $discoverViewModel.activeTextField,
//                    isTimePicked: $discoverViewModel.isTimePicked,
                    showSearchLocationView: $discoverViewModel.showSearchLocationView
                ) {
                    discoverViewModel.showSearchLocation()
                }
                    .safeAreaPadding()
                    .frame(height: 150)
                    .padding(.bottom)
                
                    .background( .gray.opacity(0.27))
                    .background( .white.opacity(0.8))
                
            case .search:
                
                    LocationSearchView(
//                        isTimePicked: $isTimePicked,
                        showSearchLocationView: $discoverViewModel.showSearchLocationView,
                        isSearch: $discoverViewModel.isSearch,
                        discoverViewModel: discoverViewModel
                    ) {
                        discoverViewModel.search()
                        }
//                        .environmentObject(locationViewModel)
                        .onDisappear {
                            
                        }
                
            case .result, .routeDetail :
                SearchCardMinimize(
                    action: {},
                    from: discoverViewModel.startingPoint,
                    to: discoverViewModel.destinationPoint
                )
                .safeAreaPadding()
            }
            
        
            
            
            if discoverViewModel.viewState != .search {
                GeometryReader { geometry in
                    let heightPosition = if selectedDetent == .medium || selectedDetent == .large { geometry.size.height - 420 } else {
                        geometry.size.height - 130
                    }
                    
                    Button(action: {
                        // Your action here (e.g. center map)
                    }) {
                        Image(systemName: "location")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(radius: 1, x: 0, y: 1)
                    }
                    
                    .position(x: geometry.size.width - 30, y: discoverViewModel.isSheetPresented ? heightPosition : geometry.size.height - 30)
                    
                }
            }
        }
                            
        
        .sheet(isPresented: $discoverViewModel.isSheetPresented) {
            VStack {
                
            }
            .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .presentationBackground(discoverViewModel.viewState == .result ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(Color.white))
            .bottomMaskForSheet()
        }
        
    }
}

#Preview {
    DiscoverView(
        discoverViewModel: DiscoverViewModel()
    )
}

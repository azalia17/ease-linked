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
    @Binding var isPresented: Bool
    
    @Environment(\.verticalSizeClass) private var sizeClass
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(initialPosition: cameraPosition) {
                UserAnnotation().tint(.blue)
                Marker(discoverViewModel.startLocationQueryFragment, systemImage: "mappin.circle.fill", coordinate: discoverViewModel.selectedStartCoordinate)
                    .tint(.red.gradient)
                
                Marker(discoverViewModel.endLocationQueryFragment, systemImage: "flag.circle.fill", coordinate: discoverViewModel.selectedEndCoordinate)
                    .tint(.red.gradient)
                
                if discoverViewModel.viewState == .routeDetail {
                    ForEach(discoverViewModel.busStopsGenerated) { identifiableCoordinate in
                        Marker(identifiableCoordinate.busStopName,
                               systemImage: "bus",
                               coordinate: identifiableCoordinate.coordinate
                        ) // Access the coordinate here
                        .tint(.orange.gradient)
                    }
                }
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
                    startingPoint: $discoverViewModel.startLocationQueryFragment,
                    destinationPoint: $discoverViewModel.endLocationQueryFragment,
                    activeTextField: $discoverViewModel.activeTextField,
                    viewState: $discoverViewModel.viewState
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
                    showSearchLocationView: $discoverViewModel.showSearchLocationView,
                    isSearch: $discoverViewModel.isSearch,
                    discoverViewModel: discoverViewModel
                ) {
                    discoverViewModel.search()
                }
                
            case .result, .routeDetail :
                SearchCardMinimize(
                    action: {
                        discoverViewModel.updateViewState(.search)
                    },
                    from: discoverViewModel.startLocationQueryFragment,
                    to: discoverViewModel.endLocationQueryFragment
                )
                .safeAreaPadding()
            }
            
            if discoverViewModel.viewState != .search {
                GeometryReader { geometry in
                    let heightPosition = if selectedDetent == .medium || selectedDetent == .large { geometry.size.height - 420 } else {
                        geometry.size.height - 130
                    }
                    let trailingPosition = if discoverViewModel.viewState == .result || discoverViewModel.viewState == .routeDetail { geometry.size.width - 50 } else { geometry.size.width - 30 }
                    
                    HStack{
                        if discoverViewModel.viewState == .result || discoverViewModel.viewState == .routeDetail {
                            Button(
                                action: {
                                    discoverViewModel.getDirections()
                                }) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(width: 36, height: 36)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .shadow(radius: 1, x: 0, y: 1)
                                }
                                .disabled(!discoverViewModel.availableRoutes.isEmpty)
                        }
                        Button(
                            action: {
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
                        
                    }
                    
                    .position(x: trailingPosition, y: discoverViewModel.isSheetPresented ? heightPosition : geometry.size.height - 30)
                }
            }
        }
        
        
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                ScrollView {
                    VStack {
                        if discoverViewModel.viewState == .result {
                            RoutesResult(generatedRoutes: discoverViewModel.availableRoutes)
                        }
                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("\(discoverViewModel.availableRoutes.count) routes you can take")
                            .font(.title3)
                            .bold()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            action: {
                                
                            },
                            label : {
                                Image(systemName: "xmark")
                                    .bold()
                                    .foregroundStyle(Color(.systemGray))
                            })
                        .buttonStyle(.bordered)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    }
                })
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
//    DiscoverView(
//        discoverViewModel: DiscoverViewModel()
//    )
}

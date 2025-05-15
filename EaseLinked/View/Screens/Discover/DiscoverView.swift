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
    
    @State private var selectedDetent: PresentationDetent = .medium
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
                        geometry.size.height - 90
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
                    if discoverViewModel.viewState == .result {
                        VStack {
                            if discoverViewModel.viewState == .result {
                                RoutesResult(
                                    generatedRoutes: discoverViewModel.availableRoutes,
                                    action: discoverViewModel.selectRoute
                                )
                            }
                        }
                    }
                    else {
                        
                        RouteSelectedDetail(generatedRoutes: discoverViewModel.selectedRoutes!, estimatedTimeSpent: 10, buses: Bus.getBusses(byRoutes: discoverViewModel.selectedRoutes?.routesId ?? []), startLocation: discoverViewModel.startLocationQueryFragment, walkingTime: 10, scheduleTime: [])
                            .padding(.horizontal)
                        
                    }
                }
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarLeading) {
                            if discoverViewModel.viewState == .result {
                                Text("\(discoverViewModel.availableRoutes.count) routes you can take")
                                    .font(.title3)
                                    .bold()
                            } else {
                                JourneyTile(startWalkingTime: 10, startStop: discoverViewModel.selectedRoutes!.busStop[0].name, endStop: discoverViewModel.selectedRoutes!.busStop[discoverViewModel.selectedRoutes!.busStop.count - 1].name, endWalkingTime: 10)
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack(spacing: 2) {
                                if discoverViewModel.viewState == .routeDetail {
                                    Button(
                                        action: {
                                            
                                        },
                                        label : {
                                            Image(systemName: "plus")
                                                .bold()
                                                .foregroundStyle(Color(.systemGray))
                                        })
                                    .buttonStyle(.bordered)
                                    .background(Color(.systemGray2))
                                    .clipShape(Circle())
                                    
                                    Button(
                                        action: {
                                            
                                        },
                                        label : {
                                            Image(systemName: "info")
                                                .bold()
                                                .foregroundStyle(Color(.systemGray))
                                        })
                                    .buttonStyle(.bordered)
                                    .background(Color(.systemGray2))
                                    .clipShape(Circle())
                                }
                                
                                Button(
                                    action: {
                                        if discoverViewModel.viewState == .routeDetail {
                                            discoverViewModel.updateViewState(.result)
                                        } else {
                                            discoverViewModel.updateViewState(.search)
                                        }
                                    },
                                    label : {
                                        Image(systemName: "xmark")
                                            .bold()
                                            .foregroundStyle(Color(.systemGray))
                                    })
                                .buttonStyle(.bordered)
                                .background(Color(.systemGray2))
                                .clipShape(Circle())
                            }
                        }
                    }
                    )
            }
            
            .presentationDetents([.height(60), .medium, .large], selection: $selectedDetent)
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

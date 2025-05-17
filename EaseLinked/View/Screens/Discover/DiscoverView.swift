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
    
    var cameraPositions: MapCameraPosition = .region(.init(center: .init(latitude: -6.305968, longitude: 106.672272), latitudinalMeters: 4000, longitudinalMeters: 4000))
    let locationManager = CLLocationManager()
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.305968, longitude: 106.672272),
            latitudinalMeters: 4000,
            longitudinalMeters: 4000
        )
    ))

    
    @State private var selectedDetent: PresentationDetent = .medium
    @Binding var isPresented: Bool
    
    @State var showInfoSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition) {
                UserAnnotation().tint(.blue)
                Annotation(discoverViewModel.startLocationQueryFragment, coordinate: discoverViewModel.selectedStartCoordinate, anchor: .bottom) {
                    Image(systemName: "mappin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .padding(12)
                        .background(.black.gradient, in: .circle)
                        
                }.stroke(.white, lineWidth: 1)
                Annotation(discoverViewModel.endLocationQueryFragment, coordinate: discoverViewModel.selectedEndCoordinate, anchor: .bottom) {
                    Image(systemName: "flag.pattern.checkered")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .padding(12)
                        .background(.black.gradient, in: .circle)
                        
                }.stroke(.white, lineWidth: 1)
                
                if discoverViewModel.viewState == .routeDetail && discoverViewModel.dataState == .loaded {
                    
                    ForEach(discoverViewModel.busStopsGenerated) { identifiableCoordinate in
                        Marker(identifiableCoordinate.busStopName,
                               systemImage: "bus",
                               coordinate: identifiableCoordinate.coordinate
                        )
                        .tint(discoverViewModel.selectedRoutes.routes[0].color.gradient)
                    }
                    MapPolyline(discoverViewModel.routeStartDestination!)
                        .stroke(Color(.systemGray), style: StrokeStyle(lineWidth: 5, lineCap: .round,dash: [1, 8]))
                    
                    MapPolyline(discoverViewModel.routeEndDestination!)
                        .stroke(Color(.systemGray), style: StrokeStyle(lineWidth: 5, lineCap: .round,dash: [1, 8]))
                    
                    ForEach(discoverViewModel.selectedRoutes.routePolylines, id: \.self) { polyline in
                        MapPolyline(polyline)
                            .stroke(discoverViewModel.selectedRoutes.routes[0].color, lineWidth: 5)
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
                        discoverViewModel.backToInitialState()
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
                    let trailingPosition = if discoverViewModel.viewState == .result || discoverViewModel.viewState == .routeDetail { geometry.size.width - 70 } else { geometry.size.width - 50 }
                    
                    HStack{
                        if discoverViewModel.viewState == .routeDetail && discoverViewModel.selectedRoutes.routePolylines.count != discoverViewModel.selectedRoutes.busStop.count - 1 {
                            Button(
                                action: {
                                    discoverViewModel.reRoute()
                                }) {
                                    Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(width: 36, height: 36)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .shadow(radius: 1, x: 0, y: 1)
                                }
                        } else {
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.secondary.opacity(0.0))
                        }
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
                                .disabled(discoverViewModel.dataState == .loaded || discoverViewModel.dataState == .loading)
                        }
                        Button(
                            action: {
                                if let location = locationManager.location?.coordinate {
                                    cameraPosition = .region(
                                        MKCoordinateRegion(
                                            center: location,
                                            latitudinalMeters: 2000,
                                            longitudinalMeters: 2000
                                        )
                                    )
                                }
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
                    switch discoverViewModel.dataState {
                    case .loading:
                        VStack {
                            ProgressView()
                                .padding(.top, 40)
                        }
                    case .loaded:
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
                            switch discoverViewModel.dataState {
                            case .loading:
                                ProgressView()
                                    .padding(.top, 40)
                            case .loaded:
                                RouteSelectedDetail(generatedRoutes: discoverViewModel.selectedRoutes, buses: discoverViewModel.selectedRoutes.busses, startLocation: discoverViewModel.startLocationQueryFragment, endLocation: discoverViewModel.endLocationQueryFragment, startWalkingTime: discoverViewModel.startWalkingTime, endWalkingTime: discoverViewModel.endWalkingTime, scheduleTime: [])
                                    .padding(.horizontal)
                                    .sheet(isPresented: $showInfoSheet) {
                                        RouteInfoSheet(
                                            routes: discoverViewModel.selectedRoutes.routes,
                                            showInfo: $showInfoSheet
                                        )
                                    }
                            case .error(let error):
                                Text(error)
                            }
                            
                        }
                    case .error(let error):
                        VStack {
                            Text("\(error). Please try again")
                        }
                    }
                }
                
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarLeading) {
                            if discoverViewModel.viewState == .result {
                                Text("\(discoverViewModel.availableRoutes.count) routes you can take")
                                    .font(.title3)
                                    .bold()
                            } else {
                                JourneyTile(startWalkingTime: discoverViewModel.selectedRoutes.startWalkingTime, startStop: discoverViewModel.selectedRoutes.busStop[0].name, endStop: discoverViewModel.selectedRoutes.busStop[discoverViewModel.selectedRoutes.busStop.count - 1].name, endWalkingTime: discoverViewModel.selectedRoutes.endWalkingTime)
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
                                            showInfoSheet = true
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
                                            discoverViewModel.backToResultSheet()
                                        } else {
                                            discoverViewModel.backToSearchSheet()
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

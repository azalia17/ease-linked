//
//  RouteListView.swift
//  BSDLink
//
//  Created by Azalia Amanda on 23/03/25.
//

import SwiftUI

struct RouteListView: View {
    @State private var searchTerm: String = ""
    @State private var showSearchInfo: Bool = false
    @State private var showOneTimeSearchInfo: Bool = true
    @State private var showRoute: Bool = false
    
    public var filteredRoutes: [Route] {
        if searchTerm.isEmpty {
            return Route.all
        } else {
            return Route.all.filter {
                $0.busStops.contains(searchTerm)
            }
            }
        }
    
    public var filteredBusStop: [BusStop] {
        if searchTerm.isEmpty {
            return BusStop.all
        } else {
            return BusStop.all.filter {
                $0.id.description.localizedLowercase.contains(searchTerm)
            }
            }
        }
//    }
    
    var body: some View {
        NavigationStack {
            if showRoute && !searchTerm.isEmpty {
                
                List(filteredBusStop) { halte in
                    HStack {
                        Image(systemName: "mappin") // Ikon lokasi
                        Text(halte.name) // Nama halte
                        Spacer()
                        Text(halte.id)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .onTapGesture {
                        searchTerm = halte.id
                        showRoute = false
                    }
                }
            } else {
                VStack() {
                    //Logic buat nampilin berapa route yang keliatan
                    RouteCount(count: filteredRoutes.count, isDiscover: false)
                        .safeAreaPadding(.horizontal)
                    
                    //Logic buat one time search info
                    if showOneTimeSearchInfo {
                        ZStack (alignment: .topTrailing){
                            Text("Try searching the name of a bus stop to know which routes pass by it.")
                                .padding(.trailing, 20)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black.opacity(0.7))
                            
                            
                            Button(action: {
                                showOneTimeSearchInfo = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14))
                                    .padding([.top, .trailing])
                            }
                            .foregroundStyle(.black.opacity(0.5))
                            
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        //                    .safeAreaPadding(.horizontal)
                        
                    }
                    
                    //Buat nampilin list rute yang disearch
                    List(filteredRoutes) { route in
                        NavigationLink {
                            DetailRouteView(route: route)
                        } label : {
                            RouteTile(routeName: route.name, stops: route.busStops.count)
                        }
                        //                        .cornerRadius(15)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal)
                    
                    
                    
                    
                }
                
//                VStack() {
//                    //Logic buat nampilin berapa route yang keliatan
//                    RouteCount(count: filteredRoutes.count)
//                        .safeAreaPadding(.horizontal)
//
//                    //Logic buat one time search info
//                    if showOneTimeSearchInfo {
//                        ZStack (alignment: .topTrailing){
//                            Text("Try searching the name of a bus stop to know which routes pass by it.")
//                                .padding(.trailing, 20)
//                                .padding()
//                                .multilineTextAlignment(.leading)
//                                .foregroundStyle(.black.opacity(0.7))
//
//
//                            Button(action: {
//                                showOneTimeSearchInfo = false
//                            }) {
//                                Image(systemName: "xmark")
//                                    .font(.system(size: 14))
//                                    .padding([.top, .trailing])
//                            }
//                            .foregroundStyle(.black.opacity(0.5))
//
//                        }
//                        .background(Color(.systemGray6))
//                        .cornerRadius(12)
//                        //                    .safeAreaPadding(.horizontal)
//
//                    }
//
//                    //Buat nampilin list rute yang disearch
//                    List(filteredRoutes) { route in
//                        NavigationLink {
//                            DetailRouteView(route: route)
//                        } label : {
//                            RouteTile(routeName: route.name, stops: route.busStops.count)
//                        }
//                        //                        .cornerRadius(15)
//                    }
//                    .listStyle(PlainListStyle())
//                    .padding(.horizontal)
//
//                    .navigationTitle(Text("All Routes"))
////
////                    //Buat nampilin search info
////                    .toolbar {
////                        ToolbarItem(placement: .navigationBarTrailing) {
////                            Button(action: {
////                                showSearchInfo = true
////                            }) {
////                                Image(systemName: "info.circle")
////                            }
////                        }
////                    }
////                    .sheet(isPresented: $showSearchInfo) {
////                        SearchRoutesInfo(isShow: $showSearchInfo)
////                            .presentationDetents([.fraction(0.2)])
////                    }
////
////
//                }
            }
                
            
                
        }
        .navigationTitle(Text("All Routes"))
        
        //Buat nampilin search info
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSearchInfo = true
                }) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showSearchInfo) {
            SearchRoutesInfo(isShow: $showSearchInfo)
                .presentationDetents([.fraction(0.2)])
        }
        .searchable(text: $searchTerm)
        .onSubmit {
            showRoute = false
        }
        .onChange(of: searchTerm) { oldValue, newValue in
            
            showRoute = true
        }
    }

}


//#Preview {
//    RouteListView()
//}


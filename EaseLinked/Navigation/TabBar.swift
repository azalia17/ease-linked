//
//  TabBar.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 06/05/25.
//

import SwiftUI

struct TabBar: View {
    @StateObject var discoverViewModel: DiscoverViewModel = DiscoverViewModel()
    
    @State var showSheet: Bool = false
    
    var body: some View {
        TabView {
            DiscoverView(
                discoverViewModel: discoverViewModel,
                isPresented: $showSheet
            )
            .tabItem {
                Label("Discover", systemImage: "map")
            }
            .onChange(of: discoverViewModel.viewState, { oldValue, newValue in
                if discoverViewModel.viewState == .result || discoverViewModel.viewState == .routeDetail {
                   showSheet = true
                } else {
                    showSheet = false
                }
            })
            .onAppear {
                if discoverViewModel.viewState == .result || discoverViewModel.viewState == .routeDetail {
                   showSheet = true
                }
            }

            RouteListView()
                .tabItem {
                    Label("Route List", systemImage: "list.bullet")
                }
                .onAppear {
                    showSheet = false
                }
                
        }
        .background(.thinMaterial)
    }
}

#Preview {
    TabBar()
}

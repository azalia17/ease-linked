//
//  TabBar.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 06/05/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            DiscoverView(
                discoverViewModel: DiscoverViewModel()
            )
            .tabItem {
                Label("Discover", systemImage: "map")
            }
            
            RouteListView()
                .tabItem {
                    Label("Route List", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    TabBar()
}

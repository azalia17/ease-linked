//
//  TabBar.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 06/05/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView { Text("Discover View").tabItem {
                    Label("Discover", systemImage: "map")
                }
//                .environmentObject(locationViewModel)
            
            Text("Route List")
                .tabItem {
                    Label("Route List", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    TabBar()
}

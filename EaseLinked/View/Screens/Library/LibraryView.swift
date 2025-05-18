//
//  LibraryView.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 18/05/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    
    @Query private var savedRoutes: [SavedRouteModel]
    var body: some View {
        VStack {
            if savedRoutes.isEmpty {
                Text("Start Exploring!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(savedRoutes) { route in
                        VStack{
                            Text("\(route.routesId)")
                            Text("\(formatTime(from:route.dateSaved))")
                            Text("\(route.startLocation) -> \(route.endLocation)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
//    LibraryView()
}

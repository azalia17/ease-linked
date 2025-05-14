//
//  RoutesResult.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI

struct RoutesResult: View {
    let generatedRoutes: [GeneratedRoute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            ForEach(generatedRoutes) { generatedRoute in
                RouteResultTile(
                    eta: generatedRoute.eta,
                    totalBusStop: generatedRoute.totalBusStop,
                    bestEta: generatedRoute.bestEta,
                    bestStop: generatedRoute.bestStop,
                    routes: generatedRoute.routes,
                    transitAt: generatedRoute.transitAt
                )
                .background(.white)
                
            }
        }
    }
}

#Preview {
    RoutesResult(
        generatedRoutes: [
//            GeneratedRoute(eta: 12, totalBusStop: 10, bestEta: true, bestStop: false, routes: [Route.all[0], Route.all[5]], transitAt: "The Breeze"),
//            GeneratedRoute(eta: 12, totalBusStop: 10, bestEta: false, bestStop: true, routes: [Route.all[0]]),
//            GeneratedRoute(eta: 12, totalBusStop: 10, bestEta: false, bestStop: false, routes: [Route.all[0]]),
//            GeneratedRoute(eta: 12, totalBusStop: 10, bestEta: false, bestStop: false, routes: [Route.all[0]]),
//            GeneratedRoute(eta: 12, totalBusStop: 10, bestEta: false, bestStop: false, routes: [Route.all[0]]),
        ]
    )
}

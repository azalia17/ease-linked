//
//  RoutesResult.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI

struct RoutesResult: View {
    let generatedRoutes: [GeneratedRoute]
    let action: (GeneratedRoute) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            ForEach(generatedRoutes) { generatedRoute in
                RouteResultTile(
                    eta: generatedRoute.eta,
                    totalBusStop: generatedRoute.totalBusStops,
                    bestEta: generatedRoute.bestEta,
                    bestStop: generatedRoute.bestStop,
                    routes: generatedRoute.routes,
                    transitAt: generatedRoute.transitAt,
                    actualEta: formatTime(from: generatedRoute.startStopScheduleTime[0].time)
                )
                .onTapGesture {
                    action(generatedRoute)
                }
                .background(.white)
                
            }
        }
    }
}

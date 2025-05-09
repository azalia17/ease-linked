//
//  RouteResultTile.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct RouteResultTile: View {
    let eta: Int
    let totalBusStop: Int
    let bestEta: Bool
    let bestStop: Bool
    let routes: [Route]
    var transitAt: String = ""
    
    var body: some View {
        HStack(alignment: bestEta || bestStop ? .top : .center, spacing: 14) {
            
            BusStopETAContainer(eta: eta, totalBusStop: totalBusStop, bestEta: bestEta, bestStop: bestStop)
                .padding(.vertical, 12)

            VStack(alignment: .leading, spacing: 12) {
                if(bestEta && bestStop) {
                    BestRoute.both.chip
                } else if(bestStop) {
                    BestRoute.stops.chip
                } else if (bestEta) {
                    BestRoute.eta.chip
                } else {
                    Spacer().frame(height: 0)
                }
                
                RouteName(routes: routes)
                
                VStack(alignment: .leading, spacing: 4){
                    if !transitAt.isEmpty {
                        RouteSmallDetailChip(icon: "arrow.trianglehead.branch", text: "Transit at \(transitAt)")
                    }
                    
                    RouteSmallDetail(walkingDistance: 1, estimatedTravelTime: 40)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(width: .infinity)
    }
}

#Preview {
    RouteResultTile(eta: 25, totalBusStop: 10, bestEta: true, bestStop: false, routes: [Route.all[1], Route.all[4]], transitAt: "The Breeze")
    RouteResultTile(eta: 25, totalBusStop: 10, bestEta: false, bestStop: false, routes: [Route.all[0], Route.all[5]], transitAt: "CBD Timur")
    RouteResultTile(eta: 25, totalBusStop: 10, bestEta: false, bestStop: true, routes: [Route.all[0], Route.all[1]], transitAt: "Lobby House of Tiktokers")
    RouteResultTile(eta: 25, totalBusStop: 10, bestEta: false, bestStop: true, routes: [Route.all[0]])
}

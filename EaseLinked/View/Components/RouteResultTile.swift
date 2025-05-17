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
    let actualEta: String
    let walkingDistance: Int
    let estimatedTravelTime: Int
    
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
                    
                    RouteSmallDetail(walkingDistance: walkingDistance, estimatedTravelTime: estimatedTravelTime,
                        eta:actualEta)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

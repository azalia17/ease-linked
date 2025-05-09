//
//  BusStopETAContainer.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct BusStopETAContainer: View {
    let eta: Int
    let totalBusStop: Int
    let bestEta: Bool
    let bestStop: Bool
    
    var body: some View {
        VStack (spacing: 1) {
            TotalRouteChip(total: totalBusStop, bestTotalStop: bestStop)
            EtaChip(eta: eta, bestEta: bestEta)
        }
    }
}

private struct EtaChip: View {
    let eta: Int
    let bestEta: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text("ETA")
                .font(.caption2)
                .foregroundColor(.white)
            if bestEta {
                VStack(spacing: 2) {
                    Text("\(eta)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("min")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            } else {
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(eta)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                        Text("min")
                            .font(.caption)
                            .foregroundColor(.white)
                }
            }
            
                
        }
//        .frame(width: 60)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(width: 77)
        .background(.blue)
        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
    }
    
}

private struct TotalRouteChip: View {
    let total: Int
    let bestTotalStop: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            if bestTotalStop {
                Text("\(total)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
            } else {
                Text("\(total)")
                    .fontWeight(.bold)
                        .font(.body)
                        .foregroundColor(.white)
                    
                
            }
            Text("Stops")
                .font(.caption2)
                .foregroundColor(.white)
            
                
        }
//        .frame(width: 60)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(width: 77)
        .background(.blue)
        .cornerRadius(8, corners: [.topLeft, .topRight])
    }
    
}

#Preview {
    BusStopETAContainer(eta: 10, totalBusStop: 10, bestEta: true, bestStop: false)
    BusStopETAContainer(eta: 10, totalBusStop: 10, bestEta: false, bestStop: true)
    BusStopETAContainer(eta: 10, totalBusStop: 10, bestEta: false, bestStop: false)
}

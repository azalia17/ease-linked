//
//  JourneyTile.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 10/05/25.
//

import SwiftUI

struct JourneyTile: View {
    let startWalkingTime: Int
    let startStop: String
    let endStop: String
    let endWalkingTime: Int
    var transitStop: String = ""
    var transitTime: Int = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            EstimatedTimeIcon(icon: "figure.walk", time: startWalkingTime)
            InBetweenJourneyIcon()
            Text(startStop)
                .font(.caption)
            if (!transitStop.isEmpty){
                InBetweenJourneyIcon()
                HStack(alignment: .center){
                    EstimatedTimeIcon(icon: "arrow.trianglehead.branch", time: transitTime)
                    Text(startStop)
                        .font(.caption)
                }
            }
            InBetweenJourneyIcon()
            Text(endStop)
                .font(.caption)
            InBetweenJourneyIcon()
            EstimatedTimeIcon(icon: "figure.walk", time: endWalkingTime)
        }
    }
}

private struct InBetweenJourneyIcon: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .frame(width: 9, height: 13)
            .foregroundStyle(Color(.systemGray3))
            .fontWeight(.bold)
    }
}

#Preview {
    JourneyTile(startWalkingTime: 10, startStop: BusStop.all[0].name, endStop: BusStop.all[8].name, endWalkingTime: 2000)
    JourneyTile(startWalkingTime: 10, startStop: BusStop.all[19].name, endStop: BusStop.all[100].name, endWalkingTime: 2000, transitStop: BusStop.all[11].name, transitTime: 10)
}

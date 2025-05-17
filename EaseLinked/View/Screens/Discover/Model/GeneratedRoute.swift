//
//  GeneratedRouteModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import Foundation
import MapKit

struct GeneratedRoute: Identifiable, Codable {
    var id = UUID()
    
    var eta: Int
    let totalBusStop: Int
    var bestEta: Bool
    var bestStop: Bool
    let routes: [Route]
    var transitAt: String = ""
    var startWalkingDistance: Int
    var endWalkingDistance: Int
    let estimatedTimeTravel: Int
    var busStop: [BusStop]
    
    var schedulesByStop: [String: [String]] = [:]
    
    var startStopScheduleId: Int = -1
    var startStopScheduleTime: [ScheduleTime] = []
    
    var transitStopScheduleId: Int = -1
    var transitStopScheduleTime: [ScheduleTime] = []
    
    var totalBusStops: Int {
        removeDuplicates(from: busStop).count
    }
        
    var routesId: [String] { routes.map {$0.id} }
    var busses: [Bus] {
        Bus.getBusses(byRoutes: routesId)
    }
    var transitBusStop: [BusStop] {
        if routes.count > 1 {
            [
                busStop.filter{$0.id != busStop[0].id}.filter { $0.routes.contains(routesId[1]) }.filter{
                    $0.routes.contains(routesId[0])
                }.first!
            ]
        } else {
            []
        }
    }
    
    var twoEarliestTime: [ScheduleTime] = []
}

extension GeneratedRoute {
    
    /// Remove duplicates by BusStop ID, preserving the order
    func removeDuplicates(from stops: [BusStop]) -> [BusStop] {
        var seen = Set<String>()
        return stops.filter { stop in
            guard !seen.contains(stop.id) else { return false }
            seen.insert(stop.id)
            return true
        }
    }

    var fromStartToTransit: [BusStop] {
        guard let transit = transitBusStop.first,
              let transitIndex = busStop.firstIndex(where: { $0.id == transit.id }),
              busStop.count >= 2 else {
            return []
        }
        
        let slice = busStop.dropFirst().prefix(upTo: transitIndex)
        return removeDuplicates(from: Array(slice))
    }
    
    var fromTransitToEnd: [BusStop] {
        guard let transit = transitBusStop.first,
              let lastTransitIndex = busStop.lastIndex(where: { $0.id == transit.id }),
              busStop.count >= 2 else {
            return []
        }
        
        let slice = busStop.suffix(from: lastTransitIndex + 1).dropLast()
        return removeDuplicates(from: Array(slice))
    }
}



struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Automatically generates a unique ID
    let coordinate: CLLocationCoordinate2D
    let busStopName: String
    let busStopId: String
}

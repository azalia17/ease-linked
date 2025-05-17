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
    
    let eta: Int
    let totalBusStop: Int
    let bestEta: Bool
    let bestStop: Bool
    let routes: [Route]
    var transitAt: String = ""
    let startWalkingDistance: Int
    let endWalkingDistance: Int
    let estimatedTimeTravel: Int
    var busStop: [BusStop]
//    var transitBusStop: [BusStop] = []
    
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
}


struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Automatically generates a unique ID
    let coordinate: CLLocationCoordinate2D
    let busStopName: String
    let busStopId: String
}

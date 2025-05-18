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
    var transitAt: String {
        if transitBusStop.isEmpty {
            return ""
        } else {
            return transitBusStop[0].name
        }
    }
    var startWalkingDistance: Int
    var endWalkingDistance: Int
    var startWalkingTime: Int = 0
    var endWalkingTime: Int = 0
    var estimatedTimeTravel: Int
    var busStop: [BusStop]
    
    var isSaved: Bool = false
    
    var startStopScheduleId: Int = -1
    var startStopScheduleTime: [ScheduleTime] = []
    
    var transitStopScheduleId: Int = -1
    var transitStopScheduleTime: [ScheduleTime] = []
    
    var codablePolylines: [CodablePolyline] = []

    var routePolylines: [MKPolyline] {
        codablePolylines.map { $0.mkPolyline }
    }
    
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
    var twoEarliestTransitime: [ScheduleTime] = []
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

struct CodablePolyline: Codable {
    let coordinates: [CLLocationCoordinate2D]
    
    init(polyline: MKPolyline) {
        self.coordinates = polyline.coordinates
    }
    
    var mkPolyline: MKPolyline {
        MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}


extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}


extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitude = try container.decode(CLLocationDegrees.self)
        let longitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}



struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Automatically generates a unique ID
    let coordinate: CLLocationCoordinate2D
    let busStopName: String
    let busStopId: String
}


//
//  SavedRouteModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 18/05/25.
//

import Foundation
import SwiftData
import MapKit

@Model
class SavedRouteModel {
    var id: UUID
    var generatedRouteId: UUID
    
    var startLocation: String
    var endLocation: String
    var eta: Int
    var totalBusSTops: Int
    var routesId: [String]

    var startWalkingDistance: Int
    var endWalkingDistance: Int
    var startWalkingTime: Int
    var endWalkingTime: Int
    var estimatedTimeTravel: Int
    
    var busStopsId: [String]
    
    var startStopScheduleId: Int
    var transitStopScheduleId: Int
    
    var polylineSegmentsData: Data?
    
    var bussesId: [String]
    
    var transitBusStopId: String
    var fromStartToTransitBusStopId: [String]
    var fromTransitToEndBusStopId: [String]
    
    var dateSaved: Date

    init(
            generatedRouteId: UUID = UUID(),
            startLocation: String,
            endLocation: String,
            eta: Int,
            totalBusSTops: Int,
            routesId: [String],
            startWalkingDistance: Int,
            endWalkingDistance: Int,
            startWalkingTime: Int,
            endWalkingTime: Int,
            estimatedTimeTravel: Int,
            busStopsId: [String],
            startStopScheduleId: Int,
            transitStopScheduleId: Int,
            polylineSegments: [MKPolyline],
            bussesId: [String],
            transitBusStopId: String,
            fromStartToTransitBusStopId: [String],
            fromTransitToEndBusStopId: [String],
            dateSaved: Date = Date() 
    ) {
        self.id = UUID()
        self.generatedRouteId = generatedRouteId
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.eta = eta
        self.totalBusSTops = totalBusSTops
        self.routesId = routesId
        self.startWalkingDistance = startWalkingDistance
        self.endWalkingDistance = endWalkingDistance
        self.startWalkingTime = startWalkingTime
        self.endWalkingTime = endWalkingTime
        self.estimatedTimeTravel = estimatedTimeTravel
        self.busStopsId = busStopsId
        self.startStopScheduleId = startStopScheduleId
        self.transitStopScheduleId = transitStopScheduleId
        self.polylineSegmentsData = try? JSONEncoder().encode(polylineSegments.map { CodablePolyline(polyline: $0) })
        self.bussesId = bussesId
        self.transitBusStopId = transitBusStopId
        self.fromStartToTransitBusStopId = fromStartToTransitBusStopId
        self.fromTransitToEndBusStopId = fromTransitToEndBusStopId
        self.dateSaved = dateSaved
    }

        var decodedPolylines: [MKPolyline] {
            guard let polylineSegmentsData,
                  let codable = try? JSONDecoder().decode([CodablePolyline].self, from: polylineSegmentsData)
            else { return [] }

            return codable.map { $0.mkPolyline }
        }
    }

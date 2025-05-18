//
//  DiscoverViewModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import Foundation
@preconcurrency import MapKit

enum DiscoverViewState {
    case initial
    case search
    case result
    case routeDetail
}

enum DiscoverDataState: Equatable {
    case loading
    case loaded
    case error(String)
}

enum RerouteState: Equatable {
    case initial
    case loading
}


final class DiscoverViewModel : NSObject, ObservableObject {
    @Published var viewState: DiscoverViewState = .initial
    @Published var dataState: DiscoverDataState = .loading
    @Published var reRouteState: RerouteState = .initial
    
    @Published var activeTextField: String = "from"
    @Published var isTimePicked: Bool = false
    @Published var showSearchLocationView: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isSearch: Bool = false
    
    
    @Published var results = [MKLocalSearchCompletion]()
    
    @Published var busStopData: [String : [String]] = [:]
    
    //the selected from the list
    var startLocationSearch: MKLocalSearchCompletion = MKLocalSearchCompletion()
    var endLocationSearch: MKLocalSearchCompletion = MKLocalSearchCompletion()
    
    // for anotation
    @Published var selectedStartCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var selectedEndCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @Published var route: MKRoute?
    @Published var routeEndDestination: MKRoute?
    @Published var routeStartDestination: MKRoute?
    @Published var routePolylines: [MKPolyline] = []
    
    @Published var startWalkingDistance: Int = 0
    @Published var endWalkingDistance: Int = 0
    @Published var startWalkingTime: Int = 0
    @Published var endWalkingTime: Int = 0
    
    var startBusStop: BusStop?
    var endBusStop: BusStop?
    
    // what shown on the text field
    private let startLocactionSearchCompleter = MKLocalSearchCompleter()
    @Published var startLocationQueryFragment: String = "" {
        didSet {
            startLocactionSearchCompleter.queryFragment = startLocationQueryFragment
        }
    }
    
    private let endLocactionSearchCompleter = MKLocalSearchCompleter()
    @Published var endLocationQueryFragment: String = "" {
        didSet {
            endLocactionSearchCompleter.queryFragment = endLocationQueryFragment
        }
    }
   
    @Published var busStopsGenerated: [IdentifiableCoordinate] = []
    @Published var availableRoutes: [GeneratedRoute] = []
    
    @Published var selectedRoutes: GeneratedRoute = GeneratedRoute(eta: 0, totalBusStop: 0, bestEta: false, bestStop: false, routes: Route.all, startWalkingDistance: 0, endWalkingDistance: 0, estimatedTimeTravel: 0, busStop: BusStop.all)
    
    
    override init() {
        super.init()
        
        startLocactionSearchCompleter.delegate = self
        startLocactionSearchCompleter.queryFragment = startLocationQueryFragment
        
        endLocactionSearchCompleter.delegate = self
        endLocactionSearchCompleter.queryFragment = endLocationQueryFragment
    }
    
    func selectLocation(_ location: MKLocalSearchCompletion, textField: String) {
        if (textField == "from") {
            self.startLocationQueryFragment = location.title
            self.startLocationSearch = location
        } else {
            self.endLocationQueryFragment = location.title
            self.endLocationSearch = location
        }
    }
    
    func searchDirection(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        locationSearch(forLocalSearchCompletion: startLocationSearch) { response, error in
            if let error = error {
                self.updateDataState(.error("Start location search failed: \(error.localizedDescription)"))
                group.leave()
                return
            }
            
            if let item = response?.mapItems.first {
                self.selectedStartCoordinate = item.placemark.coordinate
            }
            group.leave()
        }
        
        group.enter()
        locationSearch(forLocalSearchCompletion: endLocationSearch) { response, error in
            if let error = error {
                self.updateDataState(.error("End location search failed: \(error.localizedDescription)"))
                group.leave()
                return
            }
            
            if let item = response?.mapItems.first {
                self.selectedEndCoordinate = item.placemark.coordinate
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }

    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            let update = try await updates.first { $0.location?.coordinate != nil }
            return update?.location?.coordinate
        } catch {
            self.updateDataState(.error("Cannot get user location"))
            return nil
        }
    }
    
    func getWalkingDirections() {
        Task {
            guard let userLocation = await getUserLocation() else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: self.selectedStartCoordinate))
            request.transportType = .walking
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                self.route = directions.routes.first
            } catch {
                self.updateDataState(.error("walking direction error generating"))
            }
        }
    }
    
    func findNearestBusStop(from userLocation: CLLocationCoordinate2D) -> BusStop? {
        let userLocationCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        // Find the nearest bus stop by calculating the distance to each bus stop
        var nearestBusStop: BusStop?
        var shortestDistance: CLLocationDistance = CLLocationDistanceMax
        
        for busStop in BusStop.all {
            let busStopLocation = CLLocation(latitude: busStop.latitude, longitude: busStop.longitude)
            let distance = userLocationCLLocation.distance(from: busStopLocation)
            
            if distance < shortestDistance {
                shortestDistance = distance
                nearestBusStop = busStop
            }
        }
        
        return nearestBusStop
    }
    
    func findRoutes(for busStop: BusStop) -> [Route] {
        var matchingRoutes: [Route] = []
        
        for route in Route.all {
            if route.busStops.contains(busStop.id) {
                matchingRoutes.append(route)
            }
        }
        
        return matchingRoutes
    }
    
    func getDirections() {
        self.updateDataState(.loading)
        
        searchDirection {
            guard self.selectedStartCoordinate.latitude != 0.0,
                  self.selectedEndCoordinate.latitude != 0.0 else {
                self.updateDataState(.error("Coordinates are not resolved."))
                return
            }
            
            Task {
                if let routeDetails = self.generateRoute(from: self.selectedStartCoordinate, to: self.selectedEndCoordinate) {
                    let startBusStop = routeDetails.startBusStop
                    let endBusStop = routeDetails.endBusStop
                    let routes = routeDetails.routes

                    let direct = self.getDirectRoutes(from: startBusStop, to: endBusStop)
                    let transferPaths = self.generatePathsWithTransfers(startBusStop: startBusStop, endBusStop: endBusStop, routes: routes)
                    let transferRoutes = self.convertPathsToGeneratedRoutes(paths: transferPaths)

                    let allRoutes = (direct + transferRoutes)

                    do {
                        let startRoute = try await self.getWalkingFromStopsDirections(from: self.selectedStartCoordinate, to: CLLocationCoordinate2D(latitude: startBusStop.latitude, longitude: startBusStop.longitude))
                        let endRoute = try await self.getWalkingFromStopsDirections(from: self.selectedEndCoordinate, to: CLLocationCoordinate2D(latitude: endBusStop.latitude, longitude: endBusStop.longitude))

                        self.updateWalkingRoute(startRoute: startRoute, endRoute: endRoute, allRoutes: allRoutes)

                    } catch {
                        self.updateDataState(.error("Failed to calculate walking directions"))
                    }

                } else {
                    self.updateDataState(.error("Could not generate a route."))
                }
            }

        }
    }
    
    func updateWalkingRoute(startRoute: MKRoute, endRoute: MKRoute, allRoutes: [GeneratedRoute]) {
        Task {
            updateWalkingRouteUI(startRoute: startRoute, endRoute: endRoute)
            let cleanedRoutes = self.updateAllRoutes(allRoutes: allRoutes)
            let enrichedRoutes = await self.calculateTravelTimeForAllRoutes(cleanedRoutes)
            updateRoutesLoaded(enrichedRoutes: enrichedRoutes)
        }
    }
    
    func updateWalkingRouteUI(startRoute: MKRoute, endRoute: MKRoute) {
        DispatchQueue.main.async {
            self.routeStartDestination = startRoute
            self.startWalkingDistance = Int(startRoute.distance)
            self.startWalkingTime = Int(startRoute.expectedTravelTime / 60)

            self.routeEndDestination = endRoute
            self.endWalkingDistance = Int(endRoute.distance)
            self.endWalkingTime = Int(endRoute.expectedTravelTime / 60)
        }
    }

    func updateRoutesLoaded(enrichedRoutes: [GeneratedRoute]) {
        DispatchQueue.main.async {
            self.updateBestStopAllRoutes(allRoutes: enrichedRoutes)
            self.updateDataState(.loaded)
        }
    }

    
    func updateBestStopAllRoutes(allRoutes: [GeneratedRoute]) {
        var updatedRoutes = allRoutes
        
        for i in 0..<updatedRoutes.count {
            
            updatedRoutes[i].startStopScheduleId = getStartBusStopIndex(allRoutes: updatedRoutes[i], index: 0)
            
            updatedRoutes[i].startWalkingDistance = self.startWalkingDistance
            updatedRoutes[i].endWalkingDistance = self.endWalkingDistance
            updatedRoutes[i].startWalkingTime = self.startWalkingTime
            updatedRoutes[i].endWalkingTime = self.endWalkingTime
        }

        updatedRoutes = getScheduleTimeStartStop(allRoutes: updatedRoutes)

        DispatchQueue.main.async {
            guard !updatedRoutes.isEmpty else {
                self.availableRoutes = []
                return
            }

            // Find the one with least totalBusStop
            let minStopCount = updatedRoutes.map { $0.totalBusStop }.min()
            let bestStopRouteID = updatedRoutes.first(where: { $0.totalBusStop == minStopCount })?.id

            // Find the one with least eta
            let minEta = updatedRoutes.map { $0.eta }.min()
            let bestEtaRouteID = updatedRoutes.first(where: { $0.eta == minEta })?.id

            
            let prioritizedRoutes = updatedRoutes.map { route -> GeneratedRoute in
                var updated = route
                updated.bestStop = (route.id == bestStopRouteID)
                updated.bestEta = (route.id == bestEtaRouteID)
                return updated
            }.sorted { lhs, rhs in
                // Priority: both true > bestStop only > bestEta only > others
                let lhsPriority = (lhs.bestStop ? 2 : 0) + (lhs.bestEta ? 1 : 0)
                let rhsPriority = (rhs.bestStop ? 2 : 0) + (rhs.bestEta ? 1 : 0)

                if lhsPriority != rhsPriority {
                    return lhsPriority > rhsPriority
                }

                // Secondary sort: totalBusStop, then eta
                if lhs.totalBusStop != rhs.totalBusStop {
                    return lhs.totalBusStop < rhs.totalBusStop
                }

                return lhs.eta < rhs.eta
            }

            self.availableRoutes = prioritizedRoutes

        }
    }
    
    func getTransitStopIndex(updatedRoutes: GeneratedRoute) -> Int {
        let route = updatedRoutes.routes[1]
        let fromStop = updatedRoutes.transitBusStop[0].id
        let toStop = updatedRoutes.fromTransitToEnd.isEmpty ? updatedRoutes.busStop[updatedRoutes.busStop.count - 1].id: updatedRoutes.fromTransitToEnd[0].id

        // Find the correct index in the route's busStops
        for j in 0..<(route.busStops.count - 1) {
            if route.busStops[j] == fromStop && route.busStops[j + 1] == toStop {
                return j
            }
        }
        return -1
    }
    
    func getStartBusStopIndex(allRoutes: GeneratedRoute, index: Int) -> Int {
        let updatedRoutes = allRoutes
        
        guard
            updatedRoutes.busStop.count >= 2,
            let route = updatedRoutes.routes.first
        else { return -1 }
        
        let fromStop = updatedRoutes.busStop[index].id
        let toStop = updatedRoutes.busStop[index + 1].id
        
        for j in 0..<(route.busStops.count - 1) {
            if route.busStops[j] == fromStop && route.busStops[j + 1] == toStop {
                return j
            }
        }
        
        return -1
    }
    
    func getScheduleTimeStartStop(allRoutes: [GeneratedRoute]) -> [GeneratedRoute] {
        var updatedRoutes = allRoutes
        
        for i in 0..<updatedRoutes.count {
            let scheduleUsed = updatedRoutes[i].routes[0].schedule
            
            var scheduleTime = ScheduleDetail.getScheduleTimes(
                schedule: scheduleUsed,
                index: updatedRoutes[i].startStopScheduleId,
                busStopId: updatedRoutes[i].busStop[0].id,
                route: updatedRoutes[i].routes[0].id
            )
            
            scheduleTime.sort(by: { $0.time < $1.time })
            
            let now = Date()
            for j in 0..<scheduleTime.count {
                scheduleTime[j].isPassed = scheduleTime[j].time < now
            }
            
            updatedRoutes[i].startStopScheduleTime = scheduleTime
            
            updatedRoutes[i].twoEarliestTime = getNextTwoTimesHandlingPassed(from: scheduleTime)
            
            updatedRoutes[i].eta = minutesFromNow(to: updatedRoutes[i].twoEarliestTime[0])
        }
        
        return updatedRoutes
    }
    
    func getScheduleTimeTransitStop(allRoutes: GeneratedRoute) -> GeneratedRoute {
        var updatedRoutes = allRoutes
        
        let scheduleUsed = updatedRoutes.routes[1].schedule
        
        var scheduleTime = ScheduleDetail.getScheduleTimes(
            schedule: scheduleUsed,
            index: updatedRoutes.transitStopScheduleId,
            busStopId: updatedRoutes.transitBusStop[0].id,
            route: updatedRoutes.routes[1].id
        )
        
        scheduleTime.sort(by: { $0.time < $1.time })
        
        
        let now = Date()
        for j in 0..<scheduleTime.count {
            scheduleTime[j].isPassed = scheduleTime[j].time < now
        }
        
        updatedRoutes.transitStopScheduleTime = scheduleTime
        
        updatedRoutes.twoEarliestTransitime = getNextTwoTimesHandlingPassed(from: scheduleTime)
        
        return updatedRoutes
    }
    
    //if i want the eta calculate till the next day
    func minutesFromNow(to scheduleTime: ScheduleTime) -> Int {
        let now = Date()
        var time = scheduleTime.time

        if time < now {
            time = Calendar.current.date(byAdding: .day, value: 1, to: time)!
        }

        let interval = time.timeIntervalSince(now)
        return Int(interval / 60)
    }


    func updateAllRoutes(allRoutes : [GeneratedRoute]) -> [GeneratedRoute] {
        return allRoutes.uniqued(by: { $0.busStop.map(\.id).joined(separator: "->") })
    }
    
    func updateRouteDetailUI(generatedRoute: GeneratedRoute) {
        DispatchQueue.main.async {
            self.busStopsGenerated = generatedRoute.busStop.map {
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), busStopName: $0.name, busStopId: $0.id)
            }
            self.updateDataState(.loaded)
        }
    }
    
    func calculateTravelTimeForAllRoutes(_ routes: [GeneratedRoute]) async -> [GeneratedRoute] {
        var updatedRoutes: [GeneratedRoute] = []

        for var route in routes {
            var tempPolyLines: [MKPolyline] = []
            var totalTime: TimeInterval = 0
            let waypoints = route.busStop.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }

            guard waypoints.count >= 2 else {
                route.estimatedTimeTravel = 0
                updatedRoutes.append(route)
                continue
            }

            for i in 0..<waypoints.count - 1 {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: .init(coordinate: waypoints[i]))
                request.destination = MKMapItem(placemark: .init(coordinate: waypoints[i + 1]))
                request.transportType = .automobile

                do {
                    let directions = try await MKDirections(request: request).calculate()
                    if let routeResult = directions.routes.first {
                        tempPolyLines.append(routeResult.polyline)
                        totalTime += routeResult.expectedTravelTime
                    }
                } catch {
                    self.updateDataState(.error("Route segment error: \(error.localizedDescription)"))
                }
            }
            
            let codablePolylines = tempPolyLines.map { CodablePolyline(polyline: $0) }
            route.codablePolylines = codablePolylines


            // Add walking time if available
            route.estimatedTimeTravel = Int(totalTime / 60) + self.startWalkingTime + self.endWalkingTime
            updatedRoutes.append(route)
        }

        return updatedRoutes
    }


    
    func addPolyLines(_ polyLines: [MKPolyline]) -> Void {
        DispatchQueue.main.async {
            self.routePolylines = polyLines
        }
        self.updateDataState(.loaded)
    }
    
    func deleteRoutePolylines() -> Void {
        DispatchQueue.main.async {
            self.routePolylines.removeAll()
        }
    }
    
    func getDirectRoutes(from start: BusStop, to end: BusStop) -> [GeneratedRoute] {
        var directRoutes: [GeneratedRoute] = []
        
        for route in Route.all {
            guard let startIndex = route.busStops.firstIndex(of: start.id),
                  let endIndex = route.busStops.firstIndex(of: end.id),
                  startIndex <= endIndex else { continue }
            
            let busStopIDs = Array(route.busStops[startIndex...endIndex])
            let busStopsOnRoute = busStopIDs.compactMap { id in
                BusStop.all.first(where: { $0.id == id })
            }
            
            let generatedRoute = GeneratedRoute(
                eta: 0,
                totalBusStop: busStopsOnRoute.count,
                bestEta: false,
                bestStop: false,
                routes: [route],
                startWalkingDistance: 0,
                endWalkingDistance: 0,
                estimatedTimeTravel: 0,
                busStop: busStopsOnRoute
            )
            
            directRoutes.append(generatedRoute)
        }
        
        return directRoutes
    }
    
    func convertPathsToGeneratedRoutes(paths: [[BusStop]]) -> [GeneratedRoute] {
        var result: [GeneratedRoute] = []

        for path in paths {
            // Find minimal set of routes needed to cover the whole path
            let routeSegments: [(Route, [BusStop])] = findRouteSegments(for: path)
            
            let combinedStops : [BusStop] = routeSegments.flatMap { $0.1 }
            let usedRoutes = routeSegments.map { $0.0 }.uniqued(by: { $0.id })

            let generated = GeneratedRoute(
                eta: 0,
                totalBusStop: combinedStops.count,
                bestEta: false,
                bestStop: false,
                routes: usedRoutes,
                startWalkingDistance: 0,
                endWalkingDistance: 0,
                estimatedTimeTravel: 0,
                busStop: combinedStops
            )
            
            result.append(generated)
        }

        return result
        
    }

    
    func findRouteSegments(for path: [BusStop]) -> [(Route, [BusStop])] {
        var segments: [(Route, [BusStop])] = []
        
        var i = 0
        while i < path.count - 1 {
            let start = path[i]
            let end = path[i + 1]
            
            // Find a route that contains both stops in order
            if let route = Route.all.first(where: { r in
                guard let startIndex = r.busStops.firstIndex(of: start.id),
                      let endIndex = r.busStops.firstIndex(of: end.id)
                else { return false }
                return startIndex <= endIndex
            }) {
                // Grow the segment as long as it's covered by the same route
                var segmentStops = [start]
                var j = i + 1
                while j < path.count {
                    let next = path[j]
                    if let startIndex = route.busStops.firstIndex(of: path[i].id),
                       let nextIndex = route.busStops.firstIndex(of: next.id),
                       startIndex <= nextIndex {
                        segmentStops.append(next)
                        j += 1
                    } else {
                        break
                    }
                }
                segments.append((route, segmentStops))
                i = j - 1 // next iteration starts here
            } else {
                // If no route found for this segment, move on
                i += 1
            }
        }

        return segments
    }
    
    func generatePathsWithTransfers(startBusStop: BusStop, endBusStop: BusStop, routes: [Route]) -> [[BusStop]] {
        var possiblePaths: [[BusStop]] = []
        
        // Find transit bus stops (those that appear in multiple routes)
        let transitBusStops = BusStop.all.filter { $0.isTransitStop }
        
        // Iterate through routes to find possible paths with transfers
        for route in routes {
            // Check if the route contains both start and end bus stops
            if let startIndex = route.busStops.firstIndex(of: startBusStop.id),
               let endIndex = route.busStops.firstIndex(of: endBusStop.id),
               startIndex <= endIndex {
                
                // Generate path for this route without transferring
                let busStopsOnRoute = Array(route.busStops[startIndex...endIndex]).compactMap { busStopID in
                    return BusStop.all.first { $0.id == busStopID }
                }
                possiblePaths.append(busStopsOnRoute)
                
                for transitBusStop in transitBusStops {
                    if let transferIndex = route.busStops.firstIndex(of: transitBusStop.id),
                       transferIndex > startIndex,
                       transferIndex <= endIndex {

                        let firstPart = Array(route.busStops[startIndex...transferIndex])
                        let secondPart = Array(route.busStops[transferIndex...endIndex])

                        let firstPath = firstPart.compactMap { id in
                            BusStop.all.first { $0.id == id }
                        }
                        let secondPath = secondPart.compactMap { id in
                            BusStop.all.first { $0.id == id }
                        }
                        
                        possiblePaths.append(mergeWithoutDuplicate(firstPath, secondPath))
                    }
                }

            }
        }
        
        return possiblePaths
    }
    
    func mergeWithoutDuplicate(_ first: [BusStop], _ second: [BusStop]) -> [BusStop] {
        guard let lastOfFirst = first.last,
              let firstOfSecond = second.first else {
            return first + second
        }

        if lastOfFirst.id == firstOfSecond.id {
            return first + second.dropFirst()
        } else {
            return first + second
        }
    }

    
    func generateRoute(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D) -> (startBusStop: BusStop, endBusStop: BusStop, routes: [Route])? {
        
        // Find the nearest start bus stop
        guard let startBusStop = self.findNearestBusStop(from: startLocation) else {
            self.updateDataState(.error("No nearby start bus stop found."))
            return nil
        }
        
        // Find the nearest end bus stop
        guard let endBusStop = self.findNearestBusStop(from: endLocation) else {
            self.updateDataState(.error("No nearby end bus stop found."))
            return nil
        }
        
        self.startBusStop = startBusStop
        self.endBusStop = endBusStop
        
        // Find routes that pass through the start and end bus stops
        let startRoutes = self.findRoutes(for: startBusStop)
        let endRoutes = self.findRoutes(for: endBusStop)
        
        // Filter routes that pass through both the start and end bus stops
        let matchingRoutes = startRoutes.filter { route in
            return endRoutes.contains { $0.id == route.id }
        }
        
        if matchingRoutes.isEmpty {
            self.updateDataState(.error("No matching routes found."))
            return nil
        }
        
        // Return the result with the nearest bus stops and matching routes
        return (startBusStop, endBusStop, matchingRoutes)
    }
    
    func generateBusStopCoordinates(from busStops: [BusStop]) {
        DispatchQueue.main.async {
            self.busStopsGenerated = busStops.map { busStop in
                return IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude), busStopName: busStop.name, busStopId: busStop.id)
            }
        }
    }
    
    func getWalkingFromStopsDirections(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> MKRoute {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: start))
        request.destination = MKMapItem(placemark: .init(coordinate: destination))
        request.transportType = .walking
        
        let directions = try await MKDirections(request: request).calculate()
        
        guard let route = directions.routes.first else {
            throw NSError(domain: "No walking route found", code: 0)
        }
        
        return route
    }
    
    func getNextTwoTimesHandlingPassed(from scheduleTimes: [ScheduleTime]) -> [ScheduleTime] {
        let upcoming = scheduleTimes
            .filter { !$0.isPassed }
            .sorted(by: { $0.time < $1.time })

        if upcoming.count >= 2 {
            return Array(upcoming.prefix(2))
        } else if upcoming.count == 1 {
            return [upcoming[0]] + scheduleTimes.sorted(by: { $0.time < $1.time }).prefix(1)
        } else {
            // All have passed — return the first two sorted by time
            return Array(scheduleTimes.sorted(by: { $0.time < $1.time }).prefix(2))
        }
    }
    
    func reRoute() {
        Task {
            updateReRouteState(.loading)
            var updatedRoute = selectedRoutes

            var tempPolylines: [MKPolyline] = []
            var totalTime: TimeInterval = 0
            let waypoints = updatedRoute.busStop.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }

            guard waypoints.count >= 2 else {
                self.updateDataState(.error("Not enough waypoints to regenerate route."))
                return
            }

            for i in 0..<waypoints.count - 1 {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: .init(coordinate: waypoints[i]))
                request.destination = MKMapItem(placemark: .init(coordinate: waypoints[i + 1]))
                request.transportType = .automobile

                do {
                    let directions = try await MKDirections(request: request).calculate()
                    if let route = directions.routes.first {
                        tempPolylines.append(route.polyline)
                        totalTime += route.expectedTravelTime
                    }
                } catch {
                    self.updateDataState(.error("Failed to recalculate polyline: \(error.localizedDescription)"))
                    return
                }
            }

            let codablePolylines = tempPolylines.map { CodablePolyline(polyline: $0) }
            updatedRoute.codablePolylines = codablePolylines
            updatedRoute.estimatedTimeTravel = Int(totalTime / 60) + self.startWalkingTime + self.endWalkingTime
            updateReRouteUI(updatedRoute: updatedRoute, tempPolylines: tempPolylines)
            updateReRouteState(.initial)
        }
    }
    
    func updateReRouteState(_ newState: RerouteState) {
        DispatchQueue.main.async {
            self.reRouteState = newState
        }
    }

    func updateReRouteUI(updatedRoute: GeneratedRoute, tempPolylines: [MKPolyline]) {
        DispatchQueue.main.async {
            self.selectedRoutes = updatedRoute
            self.routePolylines = tempPolylines

            if let index = self.availableRoutes.firstIndex(where: { $0.id == updatedRoute.id }) {
                self.availableRoutes[index] = updatedRoute
            }

            self.updateDataState(.loaded)
        }
    }
    
    func swapDestination(start: MKLocalSearchCompletion, end: MKLocalSearchCompletion) {
        self.startLocationQueryFragment = end.title
        self.startLocationSearch = end
        
        self.endLocationQueryFragment = start.title
        self.endLocationSearch = start
    }
    
    func showSearchLocation() {
        showSearchLocationView = true
        updateViewState(.search)
    }
    
    func search() {
        getDirections()
        isSheetPresented = true
        updateViewState(.result)
        updateDataState(.loading)
    }
    
    func retry() {
        if viewState == .result {
            getDirections()
            updateViewState(.result)
        } else if viewState == .routeDetail {
            selectRoute(generatedRoute: selectedRoutes)
            updateViewState(.routeDetail)
        }
    }
    
    func routeDetail() {
        isSheetPresented = true
        updateViewState(.routeDetail)
    }
    
    func showSheet(_ newValue: Bool) {
        isSheetPresented = newValue
    }
    
    func updateViewState(_ newState: DiscoverViewState) {
        DispatchQueue.main.async {
            self.viewState = newState
        }
    }
    
    func resetResultsCompletion() {
        self.results = [MKLocalSearchCompletion]()
    }
    
    func backToResultSheet() {
        updateViewState(.result)
        deleteRoutePolylines()
        route = MKRoute()
        routeEndDestination =  MKRoute()
        routeStartDestination =  MKRoute()
        
        selectedRoutes = GeneratedRoute(eta: 0, totalBusStop: 0, bestEta: false, bestStop: false, routes: Route.all, startWalkingDistance: 0, endWalkingDistance: 0, estimatedTimeTravel: 0, busStop: BusStop.all)
    }
    
    func backToSearchSheet() {
        updateViewState(.search)
        updateReRouteState(.initial)
        availableRoutes = []
    }
    
    func selectRoute(generatedRoute: GeneratedRoute) {
        self.updateViewState(.routeDetail)
        self.updateDataState(.loading)
        self.updateReRouteState(.initial)
        selectedRoutes = generatedRoute
        if selectedRoutes.routes.count > 1 {
            selectedRoutes.transitStopScheduleId = getTransitStopIndex(
                updatedRoutes: selectedRoutes
            )
            selectedRoutes = getScheduleTimeTransitStop(allRoutes: selectedRoutes)
        }
        
        updateRouteDetailUI(generatedRoute: selectedRoutes)
        
    }
    
    func updateDataState(_ newState: DiscoverDataState) {
        DispatchQueue.main.async {
            self.dataState = newState
        }
    }
    
    func backToInitialState() {
        self.updateViewState(.initial)
        self.activeTextField = "from"
        self.isTimePicked = false
        self.showSearchLocationView = false
        self.isSheetPresented = false
        self.isSearch = false
        self.results = []
        self.busStopData = [:]
        self.startLocationSearch = MKLocalSearchCompletion()
        self.endLocationSearch = MKLocalSearchCompletion()
        self.selectedStartCoordinate = CLLocationCoordinate2D()
        self.selectedEndCoordinate = CLLocationCoordinate2D()
        self.route = MKRoute()
        self.routeEndDestination =  MKRoute()
        self.routeStartDestination =  MKRoute()
        self.routePolylines = []
        self.startWalkingDistance = 0
        self.endWalkingDistance = 0
        self.startWalkingTime = 0
        self.endWalkingTime = 0
        self.updateDataState(.loading)
        self.availableRoutes = []
        self.startLocationQueryFragment = ""
        self.endLocationQueryFragment = ""
        self.busStopsGenerated = []
        self.selectedRoutes = GeneratedRoute(eta: 0, totalBusStop: 0, bestEta: false, bestStop: false, routes: Route.all, startWalkingDistance: 0, endWalkingDistance: 0, estimatedTimeTravel: 0, busStop: BusStop.all)
        self.reRouteState = .initial
    }
}


extension DiscoverViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}


//
//  DiscoverViewModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import Foundation
import MapKit

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

enum SearchDirectionState: Equatable {
    case wait
    case finish
}

final class DiscoverViewModel : NSObject, ObservableObject {
    @Published var viewState: DiscoverViewState = .initial
    @Published var dataState: DiscoverDataState = .loading
    @Published var searchState: SearchDirectionState = .wait
    
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
    
    @Published var bestRoutes: [Route] = []
    
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
    
//    func searchDirection() {
//        searchState = .wait
//        print("1. \(searchState)")
//        locationSearch(forLocalSearchCompletion: startLocationSearch) { response, error in
//            if let error = error {
//                self.updateDataState(.error("DEBUG: Location search failed with error \(error.localizedDescription)"))
//                return
//            }
//            
//            guard let item = response?.mapItems.first else {
//                self.updateDataState(.error("startLocationSearch failed"))
//                return
//            }
//            let coordinate = item.placemark.coordinate
//            
//            self.selectedStartCoordinate = coordinate
//            self.searchState = .wait
//            print("2. \(self.searchState)")
//            
//            if self.selectedStartCoordinate != CLLocationCoordinate2D() && self.selectedEndCoordinate == CLLocationCoordinate2D() {
//                self.searchState = .finish
//            }
//        }
//        
//        locationSearch(forLocalSearchCompletion: endLocationSearch) { response, error in
//            if let error = error {
//                self.updateDataState(.error("DEBUG: Location search failed with error \(error.localizedDescription)"))
//                return
//            }
//            
//            guard let item = response?.mapItems.first else {
//                self.updateDataState(.error("endLocationSearch failed"))
//                return
//            }
//            let coordinate = item.placemark.coordinate
//            
//            self.selectedEndCoordinate = coordinate
//            self.searchState = .wait
//            print("3. \(self.searchState)")
//            print("6. \(self.selectedEndCoordinate) | \(self.selectedStartCoordinate)")
//            if self.selectedStartCoordinate != CLLocationCoordinate2D() && self.selectedEndCoordinate == CLLocationCoordinate2D() {
//                self.searchState = .finish
//            }
//        }
//        print("4. \(searchState)")
//        print("5. \(selectedEndCoordinate) | \(selectedStartCoordinate)")
//        searchState = .finish
//    }
    
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
            self.searchState = .finish
//            print("✅ Coordinates resolved: \(self.selectedStartCoordinate) | \(self.selectedEndCoordinate)")
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
    
//    func getDirections() {
//        self.updateDataState(.loading)
//        searchDirection()
//        
//        if self.selectedStartCoordinate != CLLocationCoordinate2D() && self.selectedEndCoordinate == CLLocationCoordinate2D() {
//            searchDirection()
//        }
//        
//        print("print(searchState) :\(searchState)")
//
//        if searchState == .finish {
//            guard self.selectedStartCoordinate.latitude != 0.0,
//                  self.selectedStartCoordinate.longitude != 0.0,
//                  self.selectedEndCoordinate.latitude != 0.0,
//                  self.selectedEndCoordinate.longitude != 0.0 else {
//                self.updateDataState(.error("Invalid coordinates, retrying once valid coordinates are available."))
//                return
//            }
//
//            Task {
//                if let routeDetails = generateRoute(from: self.selectedStartCoordinate, to: self.selectedEndCoordinate) {
//                    let startBusStop = routeDetails.startBusStop
//                    let endBusStop = routeDetails.endBusStop
//                    let routes = routeDetails.routes
//                    
//                    let direct = getDirectRoutes(from: startBusStop, to: endBusStop)
//
//                    let transferPaths = generatePathsWithTransfers(startBusStop: startBusStop, endBusStop: endBusStop, routes: routes)
//                    let transferRoutes = convertPathsToGeneratedRoutes(paths: transferPaths)
//
//                    // Combine both
//                    let allRoutes = (direct + transferRoutes)
//                    
//                    getWalkingFromStopsDirections(from: self.selectedStartCoordinate, to: CLLocationCoordinate2D(latitude: startBusStop.latitude, longitude: startBusStop.longitude), type: "start")
//                    getWalkingFromStopsDirections(from: self.selectedEndCoordinate, to: CLLocationCoordinate2D(latitude: endBusStop.latitude, longitude: endBusStop.longitude), type: "end")
//                    
//                    print("selectedStartCoordinate \(selectedStartCoordinate)")
//                    print("startBusStop.longitude \(startBusStop.longitude)")
//    //                print("selectedStartCoordinate \(selectedStartCoordinate)")
//                    print("startBusStop.latitude \(startBusStop.latitude)")
//                    
//                    updateBestStopAllRoutes(allRoutes: updateAllRoutes(allRoutes: allRoutes))
//                    
//    //                if endWalkingDistance != 0 {
//                        self.updateDataState(.loaded)
//    //                }
//                } else {
//                    self.updateDataState(.error("Could not generate a route."))
//                }
//                
//            }
//        }
//    }
    
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

                    // Combine both
                    let allRoutes = (direct + transferRoutes)
                    
                    self.getWalkingFromStopsDirections(from: self.selectedStartCoordinate, to: CLLocationCoordinate2D(latitude: startBusStop.latitude, longitude: startBusStop.longitude), type: "start")
                    self.getWalkingFromStopsDirections(from: self.selectedEndCoordinate, to: CLLocationCoordinate2D(latitude: endBusStop.latitude, longitude: endBusStop.longitude), type: "end")
                    
//                    print("selectedStartCoordinate \(selectedStartCoordinate)")
//                    print("startBusStop.longitude \(startBusStop.longitude)")
//    //                print("selectedStartCoordinate \(selectedStartCoordinate)")
//                    print("startBusStop.latitude \(startBusStop.latitude)")
                    
                    self.updateBestStopAllRoutes(allRoutes: self.updateAllRoutes(allRoutes: allRoutes))
                    
                    if self.endWalkingDistance != 0 {
                        self.updateDataState(.loaded)
                    }
                } else {
                    self.updateDataState(.error("Could not generate a route."))
                }
                
            }
        }
    }

    
    func updateBestStopAllRoutes(allRoutes: [GeneratedRoute]) {
        var updatedRoutes = allRoutes  // Make a mutable copy

        for i in 0..<updatedRoutes.count {
            guard
                updatedRoutes[i].busStop.count >= 2,
                let route = updatedRoutes[i].routes.first
            else { continue }

            let fromStop = updatedRoutes[i].busStop[0].id
            let toStop = updatedRoutes[i].busStop[1].id

            // Find the correct index in the route's busStops
            for j in 0..<(route.busStops.count - 1) {
                if route.busStops[j] == fromStop && route.busStops[j + 1] == toStop {
                    updatedRoutes[i].startStopScheduleId = j
                    break
                }
            }
            
            updatedRoutes[i].startWalkingDistance = self.startWalkingDistance
            updatedRoutes[i].endWalkingDistance = self.endWalkingDistance
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

//            self.availableRoutes = updatedRoutes.map { route in
//                var updated = route
//                updated.bestStop = (route.id == bestStopRouteID)
//                updated.bestEta = (route.id == bestEtaRouteID)
//                return updated
//            }
            
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
            
            // ✅ Update isPassed based on current time
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
    
    func getRouteDetails(_ generatedRoute: GeneratedRoute) {
        Task {
            // Compute walking routes
            getWalkingFromStopsDirections(from: self.selectedStartCoordinate, to: CLLocationCoordinate2D(latitude: startBusStop!.latitude, longitude: startBusStop!.longitude), type: "start")
            
            getWalkingFromStopsDirections(from: self.selectedEndCoordinate, to: CLLocationCoordinate2D(latitude: endBusStop!.latitude, longitude: endBusStop!.longitude), type: "end")
            
            generateBusStopCoordinates(from: generatedRoute.busStop)
            
            let waypoints: [CLLocationCoordinate2D] = busStopsGenerated.map { $0.coordinate }

            guard waypoints.count >= 2 else {
                self.updateDataState(.error("waypoints is less than 2"))
                return
            }
            
            var tempPolyLines: [MKPolyline] = []

            for index in 0..<waypoints.count - 1 {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: waypoints[index]))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: waypoints[index + 1]))
                request.transportType = .automobile

                do {
                    let directions = try await MKDirections(request: request).calculate()
                    if let route = directions.routes.first {
                        tempPolyLines.append(route.polyline)
                    }
                } catch {
                    self.updateDataState(.error("Error calculating route: \(error.localizedDescription)"))
                }
            }

            addPolyLines(tempPolyLines)
        }
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
        
        getWalkingFromStopsDirections(from: startLocation, to: CLLocationCoordinate2D(latitude: startBusStop.latitude, longitude: startBusStop.longitude), type: "start")
        getWalkingFromStopsDirections(from: endLocation, to: CLLocationCoordinate2D(latitude: endBusStop.latitude, longitude: endBusStop.longitude), type: "end")
        
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
    
    func getWalkingFromStopsDirections(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, type: String ) {
        Task {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: start))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .walking
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                    updateRouteDestionation(type: type, directions: directions)
            } catch {
                self.updateDataState(.error("Get walking from stops directions failed"))
            }
        }
    }
    
    func updateRouteDestionation(type: String, directions: MKDirections.Response) {
        DispatchQueue.main.async {
            if (type == "start") {
                self.routeStartDestination = directions.routes.first
                self.startWalkingDistance = Int(directions.routes.first?.distance ?? 0.0)
            } else {
                self.routeEndDestination = directions.routes.first
                self.endWalkingDistance = Int(directions.routes.first?.distance ?? 0.0)
            }
        }
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

    
    func swapDestination(start: MKLocalSearchCompletion, end: MKLocalSearchCompletion) {
        self.startLocationQueryFragment = end.title
        self.startLocationSearch = end
        
        self.endLocationQueryFragment = start.title
        self.endLocationSearch = start
    }
    
    func extractNumber(from string: String) -> Int {
        let components = string.split(separator: "_")
        if let numberString = components.last, let number = Int(numberString) {
            return number
        }
        return 0  // Default to 0 if the number cannot be extracted
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
        availableRoutes = []
    }
    
    func selectRoute(generatedRoute: GeneratedRoute) {
        self.updateViewState(.routeDetail)
        self.updateDataState(.loading)
        selectedRoutes = generatedRoute
        getRouteDetails(generatedRoute)
    }
    
    func updateDataState(_ newState: DiscoverDataState) {
        DispatchQueue.main.async {
            self.dataState = newState
        }
    }
    
    func backToInitialState() {
        self.updateViewState(.initial)
    }
}


extension DiscoverViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}


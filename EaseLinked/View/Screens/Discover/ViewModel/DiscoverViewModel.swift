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

final class DiscoverViewModel : NSObject, ObservableObject {
    @Published var viewState: DiscoverViewState = .initial
    @Published var dataState: DiscoverDataState = .loading
    
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
    
    func searchDirection() {
        locationSearch(forLocalSearchCompletion: startLocationSearch) { response, error in
            if let error = error {
                self.updateDataState(.error("DEBUG: Location search failed with error \(error.localizedDescription)"))
                return
            }
            
            guard let item = response?.mapItems.first else {
                self.updateDataState(.error("startLocationSearch failed"))
                return
            }
            let coordinate = item.placemark.coordinate
            
            self.selectedStartCoordinate = coordinate
        }
        
        locationSearch(forLocalSearchCompletion: endLocationSearch) { response, error in
            if let error = error {
                self.updateDataState(.error("DEBUG: Location search failed with error \(error.localizedDescription)"))
                return
            }
            
            guard let item = response?.mapItems.first else {
                self.updateDataState(.error("endLocationSearch failed"))
                return
            }
            let coordinate = item.placemark.coordinate
            
            self.selectedEndCoordinate = coordinate
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
        searchDirection()

        guard self.selectedStartCoordinate.latitude != 0.0,
              self.selectedStartCoordinate.longitude != 0.0,
              self.selectedEndCoordinate.latitude != 0.0,
              self.selectedEndCoordinate.longitude != 0.0 else {
            self.updateDataState(.error("Invalid coordinates, retrying once valid coordinates are available."))
            return
        }

        Task {
            if let routeDetails = generateRoute(from: self.selectedStartCoordinate, to: self.selectedEndCoordinate) {
                let startBusStop = routeDetails.startBusStop
                let endBusStop = routeDetails.endBusStop
                let routes = routeDetails.routes
                
                let direct = getDirectRoutes(from: startBusStop, to: endBusStop)

                let transferPaths = generatePathsWithTransfers(startBusStop: startBusStop, endBusStop: endBusStop, routes: routes)
                let transferRoutes = convertPathsToGeneratedRoutes(paths: transferPaths)

                // Combine both
                let allRoutes = (direct + transferRoutes)
                
                updateAllRoutes(allRoutes: allRoutes)

//                availableRoutes = direct + transferRoutes
                
                
                // Define a function to find the route that matches the bus stops in order
//                func findRoute(forBusStops busStopsToSearch: [String], in routes: [Route]) -> Route? {
//                    // Iterate over each route
//                    for route in routes {
//                        let busStops = route.busStops
//                        
//                        // Check if the busStops in the route match the busStopsToSearch in the exact order
//                        if isSubsequence(busStopsToSearch, in: busStops) {
//                            return route
//                        }
//                    }
//                    
//                    // If no route matches, return nil
//                    return nil
//                }
//
//                // Helper function to check if busStopsToSearch is a subsequence of busStops in the correct order
//                func isSubsequence(_ subsequence: [String], in sequence: [String]) -> Bool {
//                    var subsequenceIndex = 0
//                    for stop in sequence {
//                        if subsequenceIndex < subsequence.count && subsequence[subsequenceIndex] == stop {
//                            subsequenceIndex += 1
//                        }
//                        if subsequenceIndex == subsequence.count {
//                            return true
//                        }
//                    }
//                    return false
//                }
//
//                // Usage
//                if let matchingRoute = findRoute(forBusStops: self.busStopsGenerated.map{ $0.busStopId }, in: Route.all) {
//                    print("Found route: \(matchingRoute.name), \(matchingRoute.id)")
//                    bestRoutes = [matchingRoute]
//                } else {
//                    self.updateDataState(.error("No matching route found"))
//                    print("No matching route found")
//                }
//                
//                print("best routes \(bestRoutes)")
//                
////                busStopData = getScheduleForInterestedStops(route: bestRoutes[0], schedules: Schedule.getSchedules(by: bestRoutes[0].schedule), interestedStops: self.busStopsGenerated.map { $0.busStopId })
//                
////                print("(busStopData = getScheduleForInterestedStops(route: bestRoutes[0], schedules: Schedule.getSchedules(by: bestRoutes[0].schedule), interestedStops: self.busStopsGenerated.map { $0.busStopId })")
//                print("bus stop data \(busStopData)")
                
                
                
                self.updateDataState(.loaded)
            } else {
                self.updateDataState(.error("Could not generate a route."))
            }
        }
    }
    
    func updateAllRoutes(allRoutes : [GeneratedRoute]) -> Void {
        DispatchQueue.main.async {
            self.availableRoutes = allRoutes.uniqued(by: { $0.busStop.map(\.id).joined(separator: "->") })
        }
    }
    
    func getRouteDetails(_ generatedRoute: GeneratedRoute) -> Void {
        Task {
            
//            if viewState == .routeDetail {
//                generateBusStopCoordinates(from: generatedRoute.busStop)
            getWalkingFromStopsDirections(from: self.selectedStartCoordinate, to: CLLocationCoordinate2D(latitude: startBusStop!.latitude, longitude: startBusStop!.longitude), type: "start")
            
            getWalkingFromStopsDirections(from: self.selectedEndCoordinate, to: CLLocationCoordinate2D(latitude: endBusStop!.latitude, longitude: endBusStop!.longitude), type: "end")
            
                generateBusStopCoordinates(from: generatedRoute.busStop)
                
                let waypoints: [CLLocationCoordinate2D] = busStopsGenerated.map { $0.coordinate }
            
                guard waypoints.count >= 2 else {
                    self.updateDataState(.error("waypoints is less than 2"))
                    return
                }
                
//                deleteRoutePolylines()
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
//                            addPolyLines(route.polyline)
                        }
//                        self.updateDataState(.loading)
                    } catch {
                        self.updateDataState(.error("Error calculating route: \(error.localizedDescription)"))
                    }
//                }
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
            
            let combinedStops = routeSegments.flatMap { $0.1 }
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
    
    
    func generateBusStops(from startBusStop: BusStop, to endBusStop: BusStop, routes: [Route]) -> [BusStop]? {
        var bestRoute: Route? = nil
        var bestBusStops: [BusStop]? = nil
        var minBusStopsCount = Int.max  // We will use this to track the route with the least bus stops

        // Iterate over each route to find the valid routes with start and end bus stops
        for route in routes {
            if let startIndex = route.busStops.firstIndex(of: startBusStop.id),
               let endIndex = route.busStops.firstIndex(of: endBusStop.id),
               startIndex <= endIndex {
                
                // Get the bus stops between start and end indices (inclusive)
                let busStopIDs = Array(route.busStops[startIndex...endIndex])
                
                // Convert the bus stop IDs to BusStop objects
                let busStopsOnRoute = busStopIDs.compactMap { busStopID in
                    return BusStop.all.first { $0.id == busStopID }
                }
                
                availableRoutes.append(
                    GeneratedRoute(eta: 0, totalBusStop: busStopsOnRoute.count, bestEta: false, bestStop: false, routes: [route],
                                   startWalkingDistance: 0,
                                   endWalkingDistance: 0, estimatedTimeTravel: 0, busStop: busStopsOnRoute)
                )
                
                // Compare the count of bus stops with the current minimum
                if busStopsOnRoute.count < minBusStopsCount {
                    minBusStopsCount = busStopsOnRoute.count
                    bestRoute = route  // Update the best route with the least bus stops
                    bestBusStops = busStopsOnRoute  // Update the best route with the least bus stops
                }
            }
        }
        bestRoutes = [bestRoute ?? Route(id: "xx", name: "Xx", routeNumber: 0, busStops: [], bus: [], schedule: [], note: [], colorName: "black")]
        
//        generateBusStopCoordinates(from: bestBusStops ?? [])
        
        
        // Return the bus stops with the least number of stops, or nil if no valid route was found
        return bestBusStops
    }
    
    func getScheduleForInterestedStops(route: Route, schedules: [Schedule], interestedStops: [String]) -> [String: [String]] {
        var result: [String: [String]] = [:]
        
        // Iterate through each schedule
        for schedule in schedules {
            // Check the schedule details for the interested bus stops
            for stop in interestedStops {
                // Filter schedule details for the current stop
                let details = schedule.scheduleDetail.filter { $0.contains(stop) }
                
                // If there are matching details, merge them into the result
                if !details.isEmpty {
                    // If the bus stop is already in the result, append the details
                    if result[stop] != nil {
                        result[stop]?.append(contentsOf: details)
                    } else {
                        // Otherwise, create a new entry for the bus stop
                        result[stop] = details
                    }
                }
            }
        }
        
        // Now, for each bus stop, sort the schedule details by the number at the end
        for (stop, details) in result {
            // Sort the details by the number after the last underscore
            result[stop] = details.sorted { (first, second) -> Bool in
                let firstNumber = extractNumber(from: first)
                let secondNumber = extractNumber(from: second)
                return firstNumber < secondNumber
            }
        }
        
        return result
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
//                if (type == "start") {
                    updateRouteDestionation(type: type, directions: directions)
//                    routeStartDestination = directions.routes.first
//                } else {
//                    routeEndDestination = directions.routes.first
//                }
            } catch {
                self.updateDataState(.error("Get walking from stops directions failed"))
            }
        }
    }
    
    func updateRouteDestionation(type: String, directions: MKDirections.Response) {
        DispatchQueue.main.async {
            if (type == "start") {
                self.routeStartDestination = directions.routes.first
            } else {
                self.routeEndDestination = directions.routes.first
            }
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
//        deleteRoutePolylines()
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
    
//    func updateViewState(_ newValue: DiscoverViewState) {
//        self.viewState = newValue
//    }
}


extension DiscoverViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}


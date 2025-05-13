//
//  GeneratedRouteModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import Foundation

struct GeneratedRoute: Identifiable, Codable {
    var id = UUID()
    
    let eta: Int
    let totalBusStop: Int
    let bestEta: Bool
    let bestStop: Bool
    let routes: [Route]
    var transitAt: String = ""
}

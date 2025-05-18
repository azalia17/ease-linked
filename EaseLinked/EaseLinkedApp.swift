//
//  EaseLinkedApp.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 29/04/25.
//

import SwiftUI
import SwiftData

@main
struct EaseLinkedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedRouteModel.self)
    }
}

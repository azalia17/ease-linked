//
//  DiscoverViewModel.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import Foundation

enum DiscoverViewState {
    case initial
    case search
    case result
    case routeDetail
}

enum DiscoverDataState {
    case loading
    case loaded
    case error
}

final class DiscoverViewModel : ObservableObject {
    @Published var startingPoint: String = ""
    @Published var destinationPoint: String = ""
    @Published var activeTextField: String = ""
    @Published var isTimePicked: Bool = false
    @Published var showSearchLocationView: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isSearch: Bool = false
    
    @Published var viewState: DiscoverViewState = .initial
    
    func showSearchLocation() {
        showSearchLocationView = true
        viewState = .search
    }
    
    func search() {
        isSheetPresented = true
        viewState = .result
    }
    
    func routeDetail() {
        isSheetPresented = true
        viewState = .routeDetail
    }
}

//
//  LocationSearchView.swift
//  BSDLink
//
//  Created by Azalia Amanda on 07/04/25.
//

import SwiftUI

struct LocationSearchView: View {

    @Binding var showSearchLocationView : Bool
    @Binding var isSearch: Bool
    
    @StateObject var discoverViewModel : DiscoverViewModel
    
    @State private var showTimePicker: Bool = false
    @State private var timePicked = Date()
    
    var searchAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation(.spring){
                        discoverViewModel.updateViewState(.initial)
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .padding(.bottom, 8)
                }
                SearchCard(
                    searchHandler: {
                        discoverViewModel.search()
                    },
                    swapHandler: {
                        discoverViewModel.swapDestination(
                            start: discoverViewModel.startLocationSearch,
                            end: discoverViewModel.endLocationSearch
                        )
                    },
                    resetResultsCompletion: {
                        discoverViewModel.resetResultsCompletion()
                    },
                    startingPoint: $discoverViewModel.startLocationQueryFragment,
                    destinationPoint: $discoverViewModel.endLocationQueryFragment,
                    activeTextField: $discoverViewModel.activeTextField,
                    viewState: $discoverViewModel.viewState
                ) {}
            }
            .frame(height: 140)
            .padding()
            .background(.gray.opacity(0.2))
            
            if !discoverViewModel.results.isEmpty {
                ListOfLocation(discoverViewModel: discoverViewModel)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .accentColor(.white)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Your Location")
                                .font(.body)
                                .bold()
                        }
                        .padding(.leading, 8)
                        .padding(.vertical, 8)
                    }
                    .padding()
                    Rectangle()
                        .frame(height: 4)  
                        .foregroundStyle(Color(.systemGray5))
                        .background(Color(.systemGray5))
                    Spacer()
                }
                .background(.white)
            }
        }
        .background(.white)
    }
}

struct ListOfLocation: View {
    @StateObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(discoverViewModel.results, id: \.self) { result in
                    LocationSearchResultCell(
                        title: result.title,
                        subtitle: result.subtitle,
                        isStartLocation: discoverViewModel.activeTextField == "from" ? true : false
                    ).onTapGesture {
                        discoverViewModel.selectLocation(result, textField: discoverViewModel.activeTextField)
                    }
                }
            }
            .padding(.bottom, 70)
        }
    }
}

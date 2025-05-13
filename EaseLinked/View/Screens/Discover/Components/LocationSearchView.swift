//
//  LocationSearchView.swift
//  BSDLink
//
//  Created by Azalia Amanda on 07/04/25.
//

import SwiftUI

struct LocationSearchView: View {

//    @Binding var isTimePicked : Bool
    @Binding var showSearchLocationView : Bool
    @Binding var isSearch: Bool
    
    @StateObject var discoverViewModel : DiscoverViewModel
    
    @State var activeTextField: String = ""
    @State private var showTimePicker: Bool = false
    @State private var timePicked = Date()
    
//    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    var searchAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation(.spring){
                        showSearchLocationView.toggle()
//                        locationViewModel.resetAll()
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
                    swapHandler: {},
                    resetResultsCompletion: {/*locationViewModel.resetResultsCompletion()*/},
                    startingPoint: $discoverViewModel.startingPoint,
                    destinationPoint: $discoverViewModel.destinationPoint,
                    activeTextField: $activeTextField,
                    showSearchLocationView: $showSearchLocationView
                ) {}
            }
            .frame(height: 140)
            .padding()
            .background(.gray.opacity(0.2))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
//                    ForEach(locationViewModel.results, id: \.self) { result in
                    ForEach(0..<10, id: \.self) { result in
                        LocationSearchResultCell(
                            title: "result.title",
                            subtitle: "result.subtitle",
                            isStartLocation: false
                        ).onTapGesture {
//                            locationViewModel.selectLocation(result, textField: activeTextField)
                        }
                    }
                }
                .padding(.bottom, 70)
            }
        }
        .background(.white)
//        .sheet(isPresented: $showTimePicker) {
//            TimePicker(showTimePicker: $showTimePicker, timePicked: $timePicked, isTimePicked: $isTimePicked)
//                .presentationDetents([.fraction(0.45)])
//        }
    }
}

//#Preview {
//    @Previewable @State var startingPoint : String = ""
//    @Previewable @State var destinationPoint : String = ""
//    @Previewable @State var isTimePicked : Bool = false
//    @Previewable @State var show : Bool = false
//    
//    LocationSearchView(
//        startingPoint: $startingPoint, destinationPoint: $destinationPoint, isTimePicked: $isTimePicked,showSearchLocationView: $show
//    )
//}

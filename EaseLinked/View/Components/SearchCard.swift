//
//  SearchCard.swift
//  BSDLink
//
//  Created by Azalia Amanda on 31/03/25.
//

/** Add function and user input **/

import SwiftUI

struct SearchCard: View {
    
    var searchHandler: () -> Void
    var swapHandler: () -> Void
    var resetResultsCompletion: () -> Void
    
    @Binding var startingPoint : String
    @Binding var destinationPoint : String
    @Binding var activeTextField : String
    
    @Binding var viewState: DiscoverViewState
    
    var action: () -> Void
    
    enum Field {
        case from
        case to
    }
    
    @FocusState private var focusedField: Field?

    
    var body: some View {
        HStack (alignment: .center) {
            HStack(alignment: .center){
                VStack(alignment: .leading) {
                    Text("From")
                        .opacity(0.7)
                    Spacer()
                    Spacer()
                    Text("To")
                        .opacity(0.7)
                    Spacer()
                }
                if (viewState == .search) {
                    VStack {
                        Spacer()
                            TextField("Search Location", text: $startingPoint)
                                .focused($focusedField, equals: .from)
                                .modifier(
                                    TextFieldGrayBackgroundColor(
                                        showClearButton: startingPoint != "",
                                        onClear: { startingPoint.removeAll() }
                                    )
                                )
                                .padding(.top)
                                .onChange(of: startingPoint) { oldValue, newValue in
                                    activeTextField = "from"
                                }
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .to
                                    resetResultsCompletion()
                                }
                            
                        Spacer()
                        
                        TextField("Search Location", text: $destinationPoint)
                            .focused($focusedField, equals: .to)
                            .modifier(TextFieldGrayBackgroundColor(showClearButton: destinationPoint != "", onClear: {destinationPoint = ""}))
                            .padding(.bottom)
                            .onChange(of: destinationPoint) { oldValue, newValue in
                                activeTextField = "to"
                            }
                            .submitLabel(.search)
                            .onSubmit {
                                searchHandler()
                            }
                        Spacer()
                    }.onChange(of: focusedField) { oldValue, newValue in
                        resetResultsCompletion()
                    }
                    
                } else {
                    VStack {
                        Spacer()
                        TextField("Search Location", text: $startingPoint)
                            .modifier(TextFieldGrayBackgroundColor(showClearButton: startingPoint != "", onClear: {startingPoint = ""}))
                            .padding(.top)
                            .disabled(true)
                        Spacer()
                        
                        TextField("Search Location", text: $destinationPoint)
                            .modifier(TextFieldGrayBackgroundColor(showClearButton: destinationPoint != "", onClear: {destinationPoint = ""}))
                            .padding(.bottom)
                            .disabled(true)
                        Spacer()
                    }
                    .onTapGesture {
                        action()
                    }
                }
                Spacer()
                VStack {
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        swapHandler()
                    }) {
                        Image(systemName: "rectangle.2.swap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
                    .disabled(startingPoint == "" || destinationPoint == "")
                    Spacer()
                    Spacer()
                }
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        }
        
    }
    
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    let showClearButton: Bool
    let onClear: () -> Void
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
                .padding(12)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.primary)
            if (showClearButton) {
                HStack{
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .onTapGesture {onClear()}
                    Spacer().frame(width: 12)
                }
                    
            }
        }
            
    }
}

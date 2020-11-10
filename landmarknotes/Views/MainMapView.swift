//
//  MapView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import CoreLocation

struct MainMapView: View {
    @State var isPresented: Bool = false
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""
    @State var centerCoordinate: CLLocationCoordinate2D
    @State var selectedAnnotation: CustomPointAnnotation?
 
    var body: some View {
        
            NavigationView {
                VStack() {
                    ActivityIndicatorView(isAnimating: isLoading).configure { $0.color = .red }
                    MapView(centerCoordinate: centerCoordinate, isSelected: $isPresented, selectedAnnotation: $selectedAnnotation, isLoading: $isLoading, showAlert: $showAlert, message: $message)
                    NavigationLink(destination: AddNotesView()) {
                        Text("Add Notes")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(Font.system(size: 19, weight: .semibold))
                    }
                }.sheet(isPresented: $isPresented) {
                    UserDetailView(selectedAnnotation: self.$selectedAnnotation)
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text(message))
                }.navigationBarTitle("Map of User Notes")
            }
        }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView(centerCoordinate: CLLocationCoordinate2DMake(-33.87563, 151.204841))
    }
}

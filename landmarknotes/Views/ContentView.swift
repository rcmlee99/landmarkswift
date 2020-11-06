//
//  ContentView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct ContentView: View {
    @State private var tabSelection = 0
    var locationManager = CLLocationManager()
    // Default center location
    @State var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-33.87563, 151.204841)
    
    var body: some View {
        TabView(selection: $tabSelection){
            MainMapView(centerCoordinate: centerCoordinate)
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Map")
                    }
                }
                .tag(0)
            ListView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }
                .tag(1)
        }
        .onAppear { self.getCurrentLocation() }
    }
    
    func getCurrentLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.startUpdatingLocation()
            if let coordinate = locationManager.location?.coordinate {
                centerCoordinate = coordinate
                print(centerCoordinate)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




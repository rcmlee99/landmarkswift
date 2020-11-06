//
//  MapView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

class CustomPointAnnotation: MKPointAnnotation {
    var user: UserData
    
    init(user: UserData) {
        self.user = user
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var cancellable = Set<AnyCancellable>()
    
    init(_ parent: MapView) {
        self.parent = parent
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        // Set Own user notes to blue pin and others to red pin
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            if let anAnnotation = annotation as? CustomPointAnnotation {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                if anAnnotation.user.username == "rcmlee99" {
                    pinView.pinTintColor = .blue
                } else {
                    pinView.pinTintColor = .red
                    anView = pinView
                }
                anView = pinView
            }
            anView?.canShowCallout = true
            anView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            anView?.annotation = annotation
        }

        return anView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        parent.isSelected = true
        parent.selectedAnnotation = view.annotation as? CustomPointAnnotation
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            parent.isLoading = true
            print("region changed make api call")
            parent.centerCoordinate = mapView.centerCoordinate
            LandMarkService().getUserNotes(forLocation: mapView.centerCoordinate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.parent.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.parent.showAlert = true
                    self.parent.message = "Error in API Call"
                    print(error.localizedDescription)
                }
            }, receiveValue: { NearbyUsers in

                var newAnnotations : [CustomPointAnnotation] = []
                NearbyUsers.users.forEach { user in
                    
                    let info = CustomPointAnnotation(user: user)
                    info.coordinate = CLLocationCoordinate2DMake(user.location.latitude, user.location.longitude)
                    info.title = user.username
                    info.subtitle = "\(user.location.latitude),\(user.location.longitude)"
                    newAnnotations.append(info)

                }
                self.parent.userPointAnnotation = newAnnotations
            })
            .store(in: &cancellable)
        }
        
    }
}

struct MapView: UIViewRepresentable {
    var centerCoordinate: CLLocationCoordinate2D
    @State var userPointAnnotation: [CustomPointAnnotation] = []
    @Binding var isSelected: Bool
    @Binding var selectedAnnotation: CustomPointAnnotation?
    @Binding var isLoading: Bool
    @Binding var showAlert: Bool
    @Binding var message: String
    let locationManager = CLLocationManager()
    
    init(centerCoordinate: CLLocationCoordinate2D, isSelected: Binding<Bool> = .constant(true), selectedAnnotation: Binding<CustomPointAnnotation?>, isLoading: Binding<Bool> = .constant(false), showAlert: Binding<Bool> = .constant(false), message: Binding<String>) {
        _isSelected = isSelected
        _selectedAnnotation = selectedAnnotation
        self.centerCoordinate = centerCoordinate
        _isLoading = isLoading
        _showAlert = showAlert
        _message = message
   }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        return mapView
    }

    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        uiView.addAnnotations(userPointAnnotation)
    }
}

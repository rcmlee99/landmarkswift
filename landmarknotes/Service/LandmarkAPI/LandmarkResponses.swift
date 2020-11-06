//
//  LandmarkResponses.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationData: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

extension LocationData {
    init(lat: Double, lon: Double) {
        latitude = lat
        longitude = lon
    }
}

struct UserData: Hashable, Codable {
    var username: String
    var notes: String
    var location: LocationData
}

extension UserData {
    init(username: String, notes: String, location: CLLocationCoordinate2D) {
        self.username = username
        self.notes = notes
        self.location = LocationData(lat: location.latitude, lon: location.longitude)
    }
}

struct NearbyUsers: Hashable, Codable {
    var users: [UserData]
}

struct UserNotes: Hashable, Codable {
    var user: UserData
}

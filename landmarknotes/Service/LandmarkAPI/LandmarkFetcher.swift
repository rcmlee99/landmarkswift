//
//  LandmarkFetcher.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

protocol LandMarkFetchable {
    func getUserNotes(
        forLocation location: CLLocationCoordinate2D
    ) -> AnyPublisher<NearbyUsers, APIError>
    
    func getUserNotes(
        forSearchText searchText: String
    ) -> AnyPublisher<NearbyUsers, APIError>
    
    func postUserNotes(
        forUserNotes userNotes: UserData
    ) -> AnyPublisher<UserNotes, APIError>
}

class LandMarkService: ObservableObject {
    private let session: URLSession
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String

    init(session: URLSession = .shared) {
        self.session = session
        guard let _ = apiKey else {
            fatalError("Couldn't read apiKey in Info.plist")
        }
    }

}

extension LandMarkService: LandMarkFetchable {
    func getUserNotes(
        forLocation location: CLLocationCoordinate2D
    ) -> AnyPublisher<NearbyUsers, APIError> {
        return getAPICall(with: makeGetUserNotesComponents(withLocation: location))
    }
    
    func getUserNotes(
        forSearchText searchText: String
    ) -> AnyPublisher<NearbyUsers, APIError> {
        return getAPICall(with: makeGetUserNotesComponents(withSearchText: searchText))
    }
    
    func postUserNotes(
        forUserNotes userNotes: UserData
    ) -> AnyPublisher<UserNotes, APIError> {
        return postAPICall(with: makePostUserNotesComponents(), userNotes: userNotes)
    }
    
    private func getAPICall<T>(
        with components: URLComponents
    ) -> AnyPublisher<T, APIError> where T: Decodable {
        guard let url = components.url else {
            let error = APIError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic " + apiKey!, forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
        .mapError { error in
            .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
    private func postAPICall<T>(
        with components: URLComponents, userNotes: UserData
    ) -> AnyPublisher<T, APIError> where T: Decodable {
        guard let url = components.url else {
            let error = APIError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(userNotes)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic " + apiKey!, forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
        .mapError { error in
            .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
}

private extension LandMarkService {
    struct LandmarkAPI {
        static let scheme = "https"
        static let host = "us-central1-apilandmark.cloudfunctions.net"
        static let path = "/apiuser"
    }
    
    func makeCommonComponents() -> URLComponents {
        var components = URLComponents()
            components.scheme = LandmarkAPI.scheme
            components.host = LandmarkAPI.host
            components.path = LandmarkAPI.path
        return components
    }
  
    func makeGetUserNotesComponents(
        withLocation location: CLLocationCoordinate2D
    ) -> URLComponents {
        var components = makeCommonComponents()
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "long", value: "\(location.longitude)"),
        ]
        return components
    }
    
    func makeGetUserNotesComponents(
        withSearchText searchText: String
    ) -> URLComponents {
        var components = makeCommonComponents()
        components.queryItems = [
            URLQueryItem(name: "search", value: searchText),
        ]
        return components
    }
    
    func makePostUserNotesComponents() -> URLComponents {
        return makeCommonComponents()
    }

}

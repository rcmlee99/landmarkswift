//
//  ListViewModel.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import Combine

class ListViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var errorMessage: String = ""
    @Published var dataSource: [UserData] = []
    @Published var isLoading = false
    
    private var cancellable = Set<AnyCancellable>()
    
    func nearbyUsers(_ searchText: String) {
        self.isLoading=true
        LandMarkService().getUserNotes(forSearchText: searchText)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            self.isLoading=false
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.showAlert = true
                self.errorMessage = "Error in API Call"
                print(error.localizedDescription)
            }
        }, receiveValue: { NearbyUsers in
            self.dataSource = NearbyUsers.users
        })
        .store(in: &cancellable)
    }
}

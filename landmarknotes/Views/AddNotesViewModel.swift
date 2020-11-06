//
//  AddNotesViewModel.swift
//  landmarknotes
//
//  Created by Roger Lee on 5/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import Combine

class AddNotesViewModel: ObservableObject {

    @Published var showAlert = false
    @Published var message: String = ""
    private var cancellable = Set<AnyCancellable>()

    func postNotes(addnotes: UserData) {
        LandMarkService().postUserNotes(forUserNotes: addnotes)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.showAlert = true
                self.message = "Notes Added"
                break
            case .failure(let error):
                self.showAlert = true
                self.message = "Error in API Call"
                print(error.localizedDescription)
            }
        }, receiveValue: { _ in
            
        })
        .store(in: &cancellable)
    }
}

//
//  AddNotesView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

struct AddNotesView: View {
    @State var location: CLLocationCoordinate2D
    @State var notes: String = ""
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel = AddNotesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Current Location")
            Text("\(location.latitude),\(location.longitude)")
            .font(.caption)
            .padding(.bottom, 20)
            Text("Notes")
            TextField("Enter notes...", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button(action: {
                if self.notes != "" {
                    let addnotes = UserData(username: "rcmlee99", notes: self.notes, location: self.location)
                    self.viewModel.postNotes(addnotes: addnotes)
                }
            }) {
              Text("Submit")
                .frame(minWidth: 0, maxWidth: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .font(Font.system(size: 19, weight: .semibold))
            .padding()
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.message))
        }.padding()
        .navigationBarTitle("Add Notes")
    }
}

struct AddNotesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNotesView(location: CLLocationCoordinate2D(latitude: -33.960705, longitude: 151.14))
    }
}


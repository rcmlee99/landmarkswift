//
//  StationView.swift
//  fuelapp
//
//  Created by Roger Lee on 14/7/20.
//  Copyright © 2020 JR Lee Pty Ltd. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var selectedAnnotation: CustomPointAnnotation?
    
    init(selectedAnnotation:CustomPointAnnotation) {
        self.selectedAnnotation = selectedAnnotation
    }

    var body: some View {
        NavigationView {
            VStack {
                UserDetailRowView(user: selectedAnnotation!.user)
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                  Text("Dismiss")
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
                Spacer()
            }
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(selectedAnnotation: CustomPointAnnotation(user: UserData(username: "hello77", notes: "Lorem Ipsum", location: CLLocationCoordinate2DMake(-33.87563, 151.204841))))
    }
}

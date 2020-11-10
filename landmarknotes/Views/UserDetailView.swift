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
    @Binding var selectedAnnotation: CustomPointAnnotation?
    
    init(selectedAnnotation:Binding<CustomPointAnnotation?>) {
        _selectedAnnotation = selectedAnnotation
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
        StatefulPreviewWrapper(CustomPointAnnotation(user: UserData(username: "hello77", notes: "Lorem Ipsum", location: CLLocationCoordinate2DMake(-33.87563, 151.204841)))) { UserDetailView(selectedAnnotation: $0) }
    }
}

// Wrapper preview that takes bindings as inputs
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

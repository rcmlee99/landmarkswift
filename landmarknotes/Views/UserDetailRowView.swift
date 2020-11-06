//
//  StationDetailRowView.swift
//  fuelapp
//
//  Created by Roger Lee on 14/7/20.
//  Copyright © 2020 JR Lee Pty Ltd. All rights reserved.
//

import SwiftUI

struct UserDetailRowView: View {
    var user: UserData
    
    init(user:UserData) {
        self.user = user
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.body)
                    Text("\(user.location.latitude),\(user.location.longitude)")
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            Text(user.notes)
                .font(.body)
                .padding(.top, 20)
            Spacer()
        }
        .navigationBarTitle("Detail Notes")
        .padding()
    }
}

struct UserDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserDetailRowView(user: NearbyUsersData.users[0])
            UserDetailRowView(user: NearbyUsersData.users[3])
        }
        .previewLayout(.fixed(width: 300, height: 400))
    }
}


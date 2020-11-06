//
//  ListRowView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI

struct ListRowView: View {
    var user : UserData
    
    init(user:UserData) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: UserDetailRowView(user: user)) {
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
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(user: NearbyUsersData.users[0])
        .previewLayout(.fixed(width: 300, height: 60))
    }
}

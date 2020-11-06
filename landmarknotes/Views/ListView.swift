//
//  ListView.swift
//  landmarknotes
//
//  Created by Roger Lee on 4/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @State var isPresented: Bool = false
    @ObservedObject var viewModel =  ListViewModel()
    @State var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    searchField
                    if viewModel.dataSource.isEmpty {
                        emptySection
                    } else {
                        userListSection
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Search User Note")
                ActivityIndicatorView(isAnimating: viewModel.isLoading).configure { $0.color = .red }
            }.navigationBarTitle("Search User Note")
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.errorMessage))
        }.onAppear {
            self.viewModel.nearbyUsers(self.searchText)
        }
    }
}

private extension ListView {
    var searchField: some View {
      HStack(alignment: .center) {
        TextField("e.g. search string", text: $searchText)
            .autocapitalization(.none)
      }
    }
    
    var userListSection: some View {
      Section {
        ForEach(filterUsers(users: viewModel.dataSource), id: \.self ) { userData in
            ListRowView(user: userData)
        }
      }
    }
    
    var emptySection: some View {
      Section {
        Text("No results")
          .foregroundColor(.gray)
      }
    }
    
    func filterUsers(users: [UserData]) -> [UserData] {
        if searchText == "" {
            return users
        }
        let arr1 = users.filter { $0.username.contains(searchText.lowercased()) }
        let arr2 = users.filter { $0.notes.lowercased().contains(searchText.lowercased()) }
        return Array(Set(arr1 + arr2))
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

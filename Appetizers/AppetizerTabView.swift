//
//  ContentView.swift
//  Appetizers
//
//  Created by Tolga Telseren on 10/7/24.
//

import SwiftUI

struct AppetizerTabView: View {
    var body: some View {
        TabView {
            AppetizerListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
            }
            
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
            }
            
            OrderView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Order")
            }
        }
        .accentColor(.brandPrimary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppetizerTabView()
    }
}

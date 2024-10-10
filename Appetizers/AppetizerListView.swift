//
//  AppetizerListView.swift
//  Appetizers
//
//  Created by Tolga Telseren on 10/7/24.
//

import SwiftUI

struct AppetizerListView: View {
    
   
    var body: some View {
        NavigationView {
            List(MockData.appetizers) { appetizer in
                AppetizerListCell(appetizer: appetizer)
            }
            .navigationTitle("Appetizers")
        }
    }
}
                
struct AppetizerListView_Previews: PreviewProvider {
    static var previews: some View {
        AppetizerListView()
    }
}
                

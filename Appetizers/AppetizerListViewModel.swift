//
//  AppetizerListViewModel.swift
//  Appetizers
//
//  Created by Tolga Telseren on 10/15/24.
//

import SwiftUI

final class AppetizerListViewModel: ObservableObject {
    
    @Published var appetizers: [Appetizer] = []
    
    func getAppetizers() {
        
        NetworkManager.shared.getAppetizers { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let appetizers):
                    self.appetizers = appetizers
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

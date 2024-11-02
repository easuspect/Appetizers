//
//  AppetizerListViewModel.swift
//  Appetizers
//
//  Created by Tolga Telseren on 10/15/24.
//

import SwiftUI
//final class: final anahtar kelimesi, bu sınıfın alt sınıfının oluşturulmasını engeller. Yani AppetizerListViewModel sınıfı başka bir sınıf tarafından miras alınamaz.
//ObservableObject: Bu protokol, SwiftUI için gözlemlenebilir bir nesne oluşturur. SwiftUI'nin bu sınıftaki değişiklikleri izleyebilmesi için ObservableObject protokolünü kullanırız. Böylece bu sınıfta bir değişiklik olduğunda, bu değişiklikleri dinleyen SwiftUI görünümleri (views) otomatik olarak güncellenir.

final class AppetizerListViewModel: ObservableObject {
    
//@Published: @Published bir özellik sarıcıdır (property wrapper) ve ObservableObject protokolüyle birlikte kullanıldığında, bu özellik değiştiğinde bağlı olan SwiftUI görünümlerine otomatik olarak bilgi gönderir.
    @Published var appetizers: [Appetizer] = []
    @Published var alertItem: AlertItem?
    
    func getAppetizers() {
        
        NetworkManager.shared.getAppetizers { result in
            
//            DispatchQueue.main.async, bu kod bloğunu ana iş parçacığında (main thread) çalıştırır. UI güncellemeleri her zaman ana iş parçacığında yapılmalıdır, çünkü kullanıcı arayüzü işlemleri asenkron olarak çalışır.

            DispatchQueue.main.async {
                
//                switch result: Bu yapı, getAppetizers fonksiyonunun sonucunu değerlendirir. Sonuç ya başarılı (.success) ya da hatalı (.failure) olabilir.
//                case .success(let appetizers): Eğer result başarılı olursa, appetizers adlı veri döner. Bu durumda, self.appetizers = appetizers ile, appetizers dizisi güncellenir ve bu değişiklikler SwiftUI görünümüne yansıtılır.
//                case .failure(let error): Eğer result başarısız olursa, error adlı bir hata döner. Bu hata, print(error.localizedDescription) ile konsola yazdırılır, böylece hata hakkında bilgi alınabilir.

                switch result {
                case .success(let appetizers):
                    self.appetizers = appetizers
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidData:
                        self.alertItem = AlertContext.InvalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}

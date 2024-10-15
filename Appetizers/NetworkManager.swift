//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Tolga Telseren on 10/10/24.
//

import Foundation


//Bu Swift kodunda, bir singleton olarak tanımlanmış bir NetworkManager sınıfı bulunuyor. Bu sınıf, belirli bir URL'ye istek göndererek verileri çekmek için kullanılıyor. Kodun amacı, bir API'den "appetizer" (atıştırmalıklar) verilerini almak ve bunları işlemek.


//1. final class NetworkManager
//    NetworkManager adında bir sınıf tanımlanmış.
//    final anahtar kelimesi, bu sınıfın başka bir sınıf tarafından kalıtılamayacağını (inheritance) belirtir.


final class NetworkManager {
    
    /*2. static let shared = NetworkManager()
     shared adında bir static değişken tanımlanmış. Bu, Singleton desenine uygun bir yapı sağlar.
     Bu, uygulama genelinde sadece bir tane NetworkManager örneği olmasını garanti eder. Yani, bu sınıfın başka örneği oluşturulamaz, sadece NetworkManager.shared üzerinden erişilir.*/
    
    static let shared = NetworkManager()
    
    /*3. static let baseURL = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
     baseURL, API'nin temel adresini tutan bir static sabit (constant). Bu URL, tüm API isteklerinde kullanılacak.*/
    
    /*4. private let appetizerURL = baseURL + "appetizers"
     appetizerURL adında, API'den "appetizer" verilerini almak için kullanılan tam URL'yi tutan bir sabit.
     baseURL ile "appetizers" string'ini birleştirerek tam URL oluşturulmuş.
*/
    
    static let baseURL = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
    private let appetizerURL = baseURL + "appetizers"
    
    /*5. private init() {}
     private init() fonksiyonu, bu sınıfın başka yerlerden örneklenmesini (yeni bir NetworkManager objesi oluşturulmasını) engeller.
     Sınıfın dışından bu sınıfın yapıcı fonksiyonu kullanılamaz, sadece NetworkManager.shared ile erişilebilir.*/
    
    private init() {}
    
    /*6. func getAppetizers(completed: @escaping (Result<[Appetizer], APError>) -> Void)
     getAppetizers fonksiyonu, API'den "appetizer" verilerini almak için kullanılan asenkron bir fonksiyon.
     Bu fonksiyonun parametresi olan completed, verilerin başarıyla alınması ya da hata oluşması durumunda çağrılan bir kapanıştır (closure). Result yapısı kullanılarak başarılı ya da hatalı sonuçlar döndürülür.
     Result<[Appetizer], APError>: Bu, iki durumu olan bir yapı: ya bir [Appetizer] dizisi döner ya da bir APError hatası döner.
     @escaping: Bu işaret, closure'ın fonksiyonun dışına çıkabileceğini (asenkron işlemler sırasında kullanılacağını) belirtir.*/
    
    func getAppetizers(completed: @escaping (Result<[Appetizer], APError>) -> Void) {
        
        /*7. guard let url = URL(string: appetizerURL) else { ... }
         guard let yapısı kullanılarak appetizerURL string'inden bir URL nesnesi oluşturuluyor.
         Eğer appetizerURL geçersiz bir URL ise (yani string'den bir URL oluşturulamıyorsa), completed closure'ına invalidURL hatasıyla döndürülüyor ve fonksiyon sonlandırılıyor.
*/
        guard let url = URL(string: appetizerURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        /*8. let task = URLSession.shared.dataTask
         URLSession.shared.dataTask: Bu, bir ağ isteği başlatan bir nesne. Burada URLRequest(url: url) ile verilen URL'ye bir istek gönderiliyor.
         Completion handler (tamamlama işleyicisi): İstek tamamlandığında bu kod bloğu çalıştırılacak. Bu blokta hata yönetimi, yanıt kontrolü ve veri işleme işlemleri yapılır.*/
        
        let task  = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            /*9. guard let _ = error else { ... }
             Bu satırda, eğer bir error (hata) varsa, işlemler durduruluyor ve unableToComplete hatasıyla geri dönülüyor.
             Hata olmadığı durumda, program devam eder.*/
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
     
            /*10. guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { ... }
             Burada gelen yanıtın (response) bir HTTPURLResponse olup olmadığı kontrol ediliyor. Ayrıca, statusCode'un 200 olması, isteğin başarılı olduğunu gösterir. Eğer yanıt 200 OK değilse, hata olarak invalidURL döndürülür.*/
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidURL))
                return
            }
            
            /*11. guard let data = data else { ... }
             Eğer gelen veri (data) varsa işleme devam edilir. Eğer veri yoksa invalidData hatası döndürülür.*/
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            /*12. let decoder = JSONDecoder()
             Burada bir JSONDecoder nesnesi oluşturuluyor. Bu nesne, JSON verilerini AppetizerResponse nesnesine dönüştürmek için kullanılır.*/
            do {
                let decoder = JSONDecoder()
                
                /*13. let decodedResponse = try decoder.decode(AppetizerResponse.self, from: data)
                 JSON verisi, AppetizerResponse veri modeline dönüştürülüyor. Bu işlem try ile deneniyor çünkü JSON dönüşümü sırasında hata oluşabilir.
*/
                let decodedResponse = try decoder.decode(AppetizerResponse.self, from: data)
                
                /*14. completed(.success(decodedResponse.request))
                 Eğer her şey başarılıysa, completed closure'ına başarılı sonuç, yani decodedResponse.request (alınan "appetizer" verileri) döndürülüyor.*/
                completed(.success(decodedResponse.request)) }
            catch {
                /*15. catch { completed(.failure(.invalidData)) }
                 Eğer JSON verisini decode ederken hata oluşursa, catch bloğunda bu hata yakalanır ve invalidData hatası döndürülür.*/
                completed(.failure(.invalidData))
            }
        }
        /*16. task.resume()
         task.resume(): Bu satır, ağ isteğinin başlatılmasını sağlar. URLSession işlemlerini başlatmak için resume() fonksiyonunu çağırmak gerekir.
*/
        task.resume()
    }
}

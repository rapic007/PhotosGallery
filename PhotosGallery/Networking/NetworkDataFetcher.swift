import UIKit

class NetworkDataFetcher {
    
    var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    
    func fetchImages(searchTerm: String, page: Int, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm, page: page) { data, error in
            if let error = error {
                print("Error receive requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
        func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
            let decoder = JSONDecoder()
            guard let data = from else { return nil }
            
            do {
                let objects = try decoder.decode(type.self, from: data)
                return objects
            } catch let error{
                print("Failed to decode JSON", error)
                return nil
            }
        }
}


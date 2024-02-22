import UIKit

class NetworkService {
    
    func request(searchTerm: String, page: Int, completion: @escaping (Data?, Error?) -> Void) {
        let parametrs = self.prepareParametrs(searchTerm: searchTerm, page: page)
        guard let url = self.url(params: parametrs) else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID BW9iq3fkummFQugPQFiTs0Yv90P1XnB5a17MBCja0Rs"
        return headers
    }
    
    private func prepareParametrs(searchTerm: String?, page: Int) -> [String: String] {
        var parametrs = [String: String]()
        parametrs ["query"] = searchTerm
        parametrs["page"] = String(page)
        parametrs["per_page"] = String(30)
        return parametrs
    }
    
    private func url(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}

        return components.url
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

import Combine
import Foundation

class APIClient<RequestInputType: Encodable,
                RequestResponseType: Decodable>: APIClientProtocol {
    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType) -> AnyPublisher<RequestResponseType, Error> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        do {
            let encoded = try JSONEncoder().encode(requestInput)
            request.httpBody = encoded
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                
                return data
            }
            .decode(type: RequestResponseType.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol APIClientProtocol {
    associatedtype RequestInputType: Encodable
    associatedtype RequestResponseType: Decodable
    
    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType) -> AnyPublisher<RequestResponseType, Error>
}

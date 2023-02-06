import Foundation
import Combine

struct Agent {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        return URLSession(configuration: config)
    }()
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    struct WrappedData: Codable {
        let data: String
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return self.session
            .dataTaskPublisher(for: request)
            .retry(1)
            .tryMap { result -> Response<T> in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                
                let wrapped = try decoder.decode(WrappedData.self, from: result.data)
                let value = try decoder.decode(T.self, from: wrapped.data.data(using: .utf8) ?? Data())
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

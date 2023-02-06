import Foundation
import Combine

struct Agent {
    let session = URLSession.shared
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    struct WrappedData: Codable {
        let data: String
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
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

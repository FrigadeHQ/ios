import Foundation
import Combine

enum FrigadeAPI {
    static let agent = Agent()
    static let base = URL(string: "https://api.frigade.com/v1/public")!
}

extension FrigadeAPI {
    static func flow(flowId: String) -> AnyPublisher<DataArrayResponse<FlowModel>, Error> {
        return run(URLRequest(url: base.appendingPathComponent("flows/\(flowId)")))
    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        var request = request
        if let apiKey = FrigadeProvider.config?.apiKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 15
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
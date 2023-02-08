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
    
    static func flowResponses(content: FlowResponsesModel) -> AnyPublisher<FlowResponsesStatusModel, Error> {
        var request = URLRequest(url: base.appendingPathComponent("flowResponses"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(content)
        return run(request)
    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        var request = request
        if let apiKey = FrigadeProvider.config?.apiKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

import Foundation
import Combine


public struct FrigadeConfiguration {
    public let apiKey: String
    public let userId: String?
    
    public init(apiKey: String, userId: String?) {
        self.apiKey = apiKey
        self.userId = userId
    }
}

public enum FrigadeProviderError: Error {
    case unknown
    case invalidFlow
    case API(Error)
}

extension FrigadeProviderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .API(let error):
            return "FrigadeAPI error: \(error.localizedDescription)"
        default:
            return "FrigadeAPI error \(self)"
        }
    }
}

public class FrigadeProvider {
    static var config: FrigadeConfiguration?
    
    public static func setup(configuration: FrigadeConfiguration) {
        self.config = configuration
        
    }
    
    public static func load(flowId: String, completionHandler: @escaping (Result<FrigadeFlow, FrigadeProviderError>)->Void) {
        FrigadeAPI.flow(flowId: flowId).subscribe(Subscribers.Sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    completionHandler(.failure(.API(error)))
                }
            },
            receiveValue: { response in
                // don't accept empty flows
                guard !response.data.isEmpty else {
                    completionHandler(.failure(.invalidFlow))
                    return
                }
                completionHandler(.success(FrigadeFlow(flowId: flowId, data: response.data)))
            }
        ))
    }
}

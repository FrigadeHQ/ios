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
    case API(Error)
}

extension FrigadeProviderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong."
        case .API(let error):
            return "FrigadeAPI error: \(error.localizedDescription)"
        }
    }
}

public class FrigadeProvider {
    static var config: FrigadeConfiguration?
    
    private static var cancellables = Set<AnyCancellable>()
    
    public static func setup(configuration: FrigadeConfiguration) {
        self.config = configuration
  
    }
    
    public static func load(flowId: String, completionHandler: @escaping (Result<FrigadeFlow, FrigadeProviderError>)->Void) {       
        FrigadeAPI.flow(flowId: flowId).sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                completionHandler(.failure(.API(error)))
            }
        }, receiveValue: { response in
            completionHandler(.success(FrigadeFlow(flowId: flowId, data: response.data)))
        }).store(in: &self.cancellables)
    }
}

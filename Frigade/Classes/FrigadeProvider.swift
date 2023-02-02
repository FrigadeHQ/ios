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

public enum FrigateProviderError: Error {
    case unknown
    case API(Error)
}

extension FrigateProviderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong."
        case .API(let error):
            return "FrigateAPI error: \(error.localizedDescription)"
        }
    }
}

public class FrigadeProvider {
    static var config: FrigadeConfiguration?
    
    private static var cancellables = Set<AnyCancellable>()
    
    public static func setup(configuration: FrigadeConfiguration) {
        self.config = configuration
        
    }
    
    public static func load(flowId: String, completionHandler: @escaping (Result<FrigadeFlow, FrigateProviderError>)->Void) {       
        FrigadeAPI.flow(flowId: flowId).sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                completionHandler(.failure(.API(error)))
            }
        }, receiveValue: { response in
            let dummyFlow = FrigadeFlow(data: response.data)
            completionHandler(.success(dummyFlow))
        }).store(in: &self.cancellables)
    }
}

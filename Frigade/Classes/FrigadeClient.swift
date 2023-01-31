public final class FrigadeClient {
    let name = "FrigadeClient"
    let publicApiKey: String
    
    public init(publicApiKey: String) {
        self.publicApiKey = publicApiKey
        
    }
    
    public func getPublicApiKey() -> String {
        return publicApiKey
    }
}

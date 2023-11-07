import Foundation

class StringMomentoTokenProvider : CredentialProvider {
    
    override init?(authToken: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        do {
            try super.init(authToken: authToken)
        } catch let error as NSError {
//            print("Got error \(error)")
//            return nil
            throw error
        }
    }
    
}

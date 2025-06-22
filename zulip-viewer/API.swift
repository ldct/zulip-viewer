import Foundation
import Observation

@MainActor
@Observable class NetworkClient {
    var apiKey: String = ""
    
    var sessionConfig: URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        let loginString = "xuanji@gmail.com:\(apiKey)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        sessionConfig.httpAdditionalHeaders = ["Authorization": "Basic \(base64LoginString)"]
        return sessionConfig
    }
}

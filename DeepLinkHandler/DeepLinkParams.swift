import Foundation

struct DeepLinkParams {
    
    let url: String
    var queryItems: [String: String] = [:]
    
    init (url: String) {
        self.url = url
    }
    
}
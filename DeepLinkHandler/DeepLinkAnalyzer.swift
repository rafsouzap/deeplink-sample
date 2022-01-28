import Foundation

protocol DeepLinkAnalyzerProtocol{
    var registry: [DeepLinkEntry] { get }
    func loadMappings()
}

extension DeepLinkAnalyzerProtocol {
    
    func parseURL(url: URL) -> Bool {
        
        if !UBHelpersCustomerHelper.isLogged() {
            return false
        }
        
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false), let path = components.path, let scheme = components.scheme, let host = components.host {
            loadMappings()
            
            var deepLinkPath = scheme + "://" + host
            
            // Handle deeplinks Popup-URL, Internal-URL and External-URL
            if host.hasSuffix("-url") {
                let newPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                if let encodedPath = newPath.encodeUrl() {
                    deepLinkPath += "/" + encodedPath
                }
            } else {
                deepLinkPath += path
            }
            
            for entry in registry where entry.isMatchingWithPattern(url: deepLinkPath) {
                return entry.openScreen(url: url.absoluteString, queryItems: components.queryItems)
            }
        }
        return false
    }
    
}
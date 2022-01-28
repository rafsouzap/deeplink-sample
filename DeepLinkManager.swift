import Foundation

final class DeepLinkManager: DeepLinkAnalyzerProtocol {
    
    private let scheme = "scheme-app://"
    private init() { }
    
    static let shared = DeepLinkManager()
    var registry: [DeepLinkEntry] = []
    
    func loadMappings() {

        registry.append(DeepLinkEntry(pattern: scheme.appending("product/{type}/{id}"), closure: { (params) in
            if let catalogType = params.queryItems["type"], let catalogIdStr = params.queryItems["id"] {
                guard let newId = Int64(id) else {
                    return false
                }
                // TODO: Implementation
                return true
            }
            return false
        }))
        
        registry.append(DeepLinkEntry(pattern: scheme.appending("category/{id}/{description}"), closure: { (params) in
            if let categoryIdStr = params.queryItems["id"], let subCategoryIdStr = params.queryItems["description"] {
                guard let newId = Int64(id) else {
                    return false
                }
                // TODO: Implementation
                return true
            }
            return false
        }))
    }
}
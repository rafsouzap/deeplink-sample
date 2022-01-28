import Foundation

struct DeepLinkEntry {
    
    private static let paramPattern = "\\{([^}]+)\\}"
    private static let param = "([a-zA-Z][a-zA-Z0-9_-]*)"
    private static let paramValue = "([a-zA-ZÀ-ÿ0-9_#'!+%~,\\-\\.\\@\\$\\:]+)"
    
    let pattern: DeepLinkPattern
    let closure: DeepLinkClosure
    let computedRegex: NSRegularExpression
    let predicate: NSPredicate
    
    public init(pattern: DeepLinkPattern, closure: @escaping DeepLinkClosure) {
        self.pattern = pattern
        self.closure = closure
        self.computedRegex = pattern.pathToPatternRegexBuilder(paramPattern: DeepLinkEntry.paramPattern, withPattern: DeepLinkEntry.paramValue)!
        self.predicate = NSPredicate(format:"SELF MATCHES %@", self.computedRegex.pattern)
    }
    
    public func isMatchingWithPattern(url: String) -> Bool {
        return predicate.evaluate(with:url)
    }
    
    public func openScreen(url: String, queryItems: [URLQueryItem]?) -> Bool {
        var params = DeepLinkParams(url: url)
        self.extractParams(deepLinkParams: &params, queryItems: queryItems)
        return self.closure(params)
    }
    
    func extractParams(deepLinkParams: inout DeepLinkParams, queryItems: [URLQueryItem]?) {
        if let urlParams = pattern.replacingOccurrences(of: "[\\{\\}]", with: "", options: .regularExpression, range: nil).captureGroups(regex: computedRegex) {
            let length = urlParams.count
            let values = fetchParamValues(url:deepLinkParams.url)
            for index in 0..<length {
                deepLinkParams.queryItems[urlParams[index]] = values[index].removingPercentEncoding
            }
        }
        
        if let items = queryItems {
            for item in items where item.value != nil {
                deepLinkParams.queryItems[item.name] = item.value!.removingPercentEncoding
            }
        }
    }
    
    func fetchParamValues(url: String) -> [String] {
        return url.captureGroups(regex: computedRegex)!
    }
    
}
import Foundation

typealias DeepLinkPattern = String
typealias DeepLinkClosure = (DeepLinkParams) -> Bool

extension DeepLinkPattern {
    
    func captureGroups(regex: NSRegularExpression) -> [String]? {
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard let match = matches.first else { return nil }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return nil }
        
        var results = [String]()
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }
    
    func pathToPatternRegexBuilder(paramPattern: String, withPattern: String) -> NSRegularExpression? {
        do {
            let pattern = self.replacingOccurrences(of: paramPattern, with: withPattern, options: .regularExpression, range: self.startIndex..<self.endIndex)
            return try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return nil
        }
    }
    
}
//
//  SearchResult.swift
//  ANet
//
//  Created by Gregor Schwake on 11.03.25.
//

import Foundation

struct SearchResult {
    
    let search: [Sensor]
    var found: [Sensor]
    var passed: Int
    var result: Sensor?
    
    static func max(_ searchResults: [SearchResult]) -> SearchResult {
        
        var bestResult: SearchResult = searchResults[0]
        for index in 1...(searchResults.count - 1) {
            bestResult = bestResult.max(searchResults[index])
        }
        
        return bestResult
    }
    
    
    
    // Return search info that best fits
    func max(_ searchResult: SearchResult) -> SearchResult {
        
        // A complete search info is a 100 % fit
        guard !self.isComplete() else { return self }
        guard !searchResult.isComplete() else { return searchResult }
        
        // All values found and nothing else passed but no result => wrong path
        // The same constellation but with result is filtered above via isComplete()
        guard !((self.passed == self.search.count) && (self.passed == self.found.count)) else {
            return self
        }
        guard !((searchResult.passed == searchResult.search.count) && (searchResult.passed == searchResult.found.count)) else {
            return searchResult
        }
        
        // The more found and the less passed the better
        if self.found.count > searchResult.found.count { return self }
        if self.found.count < searchResult.found.count { return searchResult }
        if self.passed < searchResult.passed {
            return self
        } else {
            return searchResult
        }
        
    }
    
    // Going further will not lead to valid result
    func isEndOfPath() -> Bool {
        guard !self.isComplete() else { return true }
        if (self.search.count == self.found.count) && (self.passed > self.search.count) {
            return true
        } else {
            return false
        }
    }
    
    func isComplete() -> Bool {
        return ((result != nil) && (found.count == search.count) && (found.count == passed))
    }
    
    
}

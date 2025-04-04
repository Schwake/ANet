//
//  NetInfo.swift
//  ANet
//
//  Created by Gregor Schwake on 25.02.25.
//

import Foundation

struct NetInfo {
    
    let nodes: Int
    let incoming: Int
    let outgoing: Int
    let depth: Int
    let results: Int
    let roots: Int
    let rootsInside: Int?
    
    
    func toString() -> String {
        
        var answer = ""
        
        answer += "Nodes:        \(nodes)\n"
        answer += "Incoming:    \(incoming)\n"
        answer += "Outgoing:    \(outgoing)\n"
        answer += "Depth:       \(depth)\n"
        answer += "Results:     \(results)\n"
        answer += "Roots:       \(roots)\n"
        answer += "RootsInside:  \(rootsInside ?? 0)\n"
        
        return answer
    }
    
}

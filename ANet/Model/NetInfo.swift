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
    
    
    func checkAcyclicGraph(net: Net) -> Int {
        
        var answer = 0
        var nodeStack: [UUID] = []
        var pathStack: [UUID] = []
        
        for nodeID in net.nodeDict.keys {
            nodeStack = [nodeID]
            pathStack = [nodeID]
            
            while !nodeStack.isEmpty {
                let currID = nodeStack.removeFirst()
                for child in net.connector.outgoing(from: currID) {
                    nodeStack.append(child)
                    pathStack.append(child)
                }
                for _ in pathStack {
                    let pathStackCopy = Set(pathStack)
                    if pathStackCopy.count != pathStack.count {
                        answer += 1
                        nodeStack.removeAll()
                        pathStack.removeAll()
                    }
                }
            }
        }
        return answer
    }
    
}

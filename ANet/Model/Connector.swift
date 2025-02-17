//
//  Connector.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import Foundation

class Connector {
    
    // outgoing connections ->
       // fromDict from -> to (forwards)
       var fromDict: [UUID: [UUID]] = [:]
       
       // incoming connections <-
       // toDict to -> from (backwards)
       var toDict: [UUID: [UUID]] = [:]
    
    
    // Add a new connection
    func connect(from fromNode: Node, to toNode: Node) {
        fromDict[fromNode.id, default: []].append(toNode.id)
        toDict[toNode.id, default: []].append(fromNode.id)
    }
    
    
    func hasConnection(from fromNode: Node, to toNode: Node) -> Bool {
        return (has(from: fromNode, to: toNode) && has(to: toNode, from:fromNode))
    }
        
    
    func has(from fromNode: Node, to toNode: Node) -> Bool {
        fromDict[fromNode.id]?.contains(toNode.id) ?? false
    }
    
    
    func has(to toNode: Node, from fromNode: Node) -> Bool {
        toDict[toNode.id]?.contains(fromNode.id) ?? false
    }
    
    
}

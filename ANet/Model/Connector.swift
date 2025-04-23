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
    
    
    // MARK: Basic
    
    // Add a new connection
    func connect(from fromNode: Node, to toNode: Node) {
        fromDict[fromNode.id, default: []].append(toNode.id)
        toDict[toNode.id, default: []].append(fromNode.id)
    }
    
    
    func hasConnection(from fromNode: Node, to toNode: Node) -> Bool {
        return (has(from: fromNode, to: toNode) && has(to: toNode, from:fromNode))
    }
    
    
    func has(from fromNode: Node, to toNode: Node) -> Bool {
        return fromDict[fromNode.id]?.contains(toNode.id) ?? false
    }
    
    
    func has(to toNode: Node, from fromNode: Node) -> Bool {
        return toDict[toNode.id]?.contains(fromNode.id) ?? false
    }
    
    
    func has(from nodeID: UUID) -> Bool {
        return fromDict.index(forKey: nodeID) != nil
    }
    
    
    func has(to nodeID: UUID) -> Bool {
        return toDict.index(forKey: nodeID) != nil
    }
    
  
    func pathFor(nodeID: UUID) -> [UUID] {
        var nodeStack = [nodeID]
        var pathStack = [nodeID]
        var checkDict: [UUID : Bool] = [nodeID : true]
        
        let start = Date()
//        print("Start PathFor: \(start.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")

        
        
        while !nodeStack.isEmpty {
            let currID = nodeStack.removeFirst()
            for child in outgoing(from: currID).sorted() {
                // do not process results
                guard has(from: child) else { continue }
                nodeStack.append(child)
                if checkDict.keys.contains(child) {
//                    print("ACYCLIC GRAPH")
//                    print("Child: \(child.uuidString)")
//                    for key in checkDict.keys {
//                        print("\(key.uuidString)")
//                    }
//                    nodeStack.removeAll()
                    break
                } else {
                        checkDict[child] = true
                }
                pathStack.append(child)
            }
        }
//        print("PathStack size: \(pathStack.count)")
        
//        let end = Date()
//        print("End PathFor: \(end.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")

        return pathStack
    }

    
    
//    func pathFor(nodeID: UUID) -> [UUID] {
//        var nodeStack = [nodeID]
//        var pathStack = [nodeID]
//        
//        while !nodeStack.isEmpty {
//            let currID = nodeStack.removeFirst()
//            for child in outgoing(from: currID) {
//                nodeStack.insert(child, at: 0)
//                pathStack.insert(child, at: 0)
//            }
//        }
//        return pathStack
//    }
    
    // MARK: Crawler info
    
    func outgoing(from nodeID: UUID) -> [UUID] {
        var answer = [UUID]()
        if let outIDs = fromDict[nodeID] {
            answer = outIDs
        }
        return answer
    }
    
    
    func incoming(to nodeID: UUID) -> [UUID] {
        var answer = [UUID]()
        if let inIDs = toDict[nodeID] {
            answer = inIDs
        }
        return answer
    }
    
    
    // MARK: Merge
    
    func isResult(nodeID: UUID) -> Bool {
        return !has(from: nodeID)
    }

    
    // Just incase - should have been dealt with in Net
    func remove(nodeID: UUID) {
        fromDict.removeValue(forKey: nodeID)
        toDict.removeValue(forKey: nodeID)
    }
    
    
    func connect(from fromNodeID: UUID, to toNodeID: UUID) {
        fromDict[fromNodeID, default: []].append(toNodeID)
        toDict[toNodeID, default: []].append(fromNodeID)
    }
    
    
    // Replace all connections TO cellA with connections to cellB
    func moveAll(oldTo nodeA: UUID, newTo nodeB: UUID) {
        if let nodes = toDict[nodeA] {
            for nodeID in nodes {
                move(from: nodeID, oldTo: nodeA, newTo: nodeB)
            }
        }
    }
    
    
    // Replace connection  from -> oldTo to from -> newTo including the to -> from connection
    func move(from nodeID: UUID, oldTo oldNodeID: UUID, newTo newNodeID: UUID) {
        
        // Remove connection in fromDict
        var newIDs = fromDict[nodeID]?.filter {$0 != oldNodeID}
        fromDict[nodeID] = newIDs
        
        // Remove connection in toDict
        newIDs = toDict[oldNodeID]?.filter {$0 != nodeID}
        toDict[oldNodeID] = newIDs
        
        // Add new connection
        connect(from: nodeID, to: newNodeID)
        
    }
    
    
    // Replace all connections FROM cellA with connections from cellB
    func moveAll(oldFrom nodeA: UUID, newFrom nodeB: UUID) {
        
        // One by one: Create new connections newFrom <-> to (outgoing/incoming)
        // One by one: Remove old connections oldFrom <- to (incoming)
        for toID in fromDict[nodeA]! {
            connect(from: nodeB, to: toID)
            let fromIDs = toDict[toID]?.filter {$0 != nodeA}
            toDict[toID] = fromIDs
        }
        
        // Remove all old connections oldFrom -> to (outgoing)
        fromDict.removeValue(forKey: nodeA)
        
    }
    
    
}

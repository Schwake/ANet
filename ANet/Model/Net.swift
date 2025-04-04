//
//  Net.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import Foundation

class Net {
    
    let connector = Connector()
    var nodeDict: [UUID : Node] = [:]
    
    // MARK: Populate
    
    func populate(sensors: [Sensor], result: Sensor) {
        let node = Node(sensors: sensors)
        nodeDict[node.id] = node
        var resultNode = Node(sensors: [result])
        resultNode.isRoot = false
        nodeDict[resultNode.id] = resultNode
        connector.connect(from: node, to: resultNode)
    }
    
    // MARK: Merge
    
    // Paths from these nodes lead to result
    func rootNodeIDs() -> [UUID] {
        var rootNodeIDs: [UUID] = []
        
        for (id, node) in nodeDict {
            if node.isRoot {
                rootNodeIDs.append(id)
            }
        }
        
        return rootNodeIDs
    }
    
    // These are root nodes that do not have incoming connections (level 0)
    func rootNodeIDsLevel0() -> [UUID] {
        let roots = rootNodeIDs()
        return roots.filter { connector.incoming(to: $0).isEmpty }
    }
    
    
    func isValid(id: UUID) -> Bool {
        return nodeDict[id] != nil
    }
    
    
    func remove(nodeID: UUID) {
        nodeDict.removeValue(forKey: nodeID)
        connector.remove(nodeID: nodeID)
    }
    
    
    func merge() {
        
        let nodeList = rootNodeIDsLevel0()
        
        var downInd = nodeList.count - 1
        let maxInd = (nodeList.count / 2) - 1
        
        for index in 0...maxInd {
            merge(left: nodeList[index], right: nodeList[downInd])
            downInd -= 1
        }
    }
    
    
    func mergeComplex() -> [UUID] {
        
        var answer: [UUID] = []
        let nodeList = rootNodeIDsLevel0()
        
        var downInd = nodeList.count - 1
        let maxInd = (nodeList.count / 2) - 1
        
        for index in 0...maxInd {
            answer.append(contentsOf: mergeComplex(left: nodeList[index], right: nodeList[downInd]))
            downInd -= 1
        }
        return answer
    }
    
    
     
    
    func mergeComplex(left leftID: UUID, right rightID: UUID) -> [UUID] {
        var answer: [UUID] = []
        let pathIDs = connector.pathFor(nodeID: leftID)
        for id in pathIDs {
            if isValid(id: id) && isValid(id: rightID) {
                answer.append(contentsOf: merge(left: id, right: rightID))
            } else {
                break
            }
        }
        return answer
    }
    
    
    func merge(left leftID: UUID, right rightID: UUID) -> [UUID] {
        var answer = [leftID, rightID]
        
        var leftNode = nodeDict[leftID]!
        var rightNode = nodeDict[rightID]!
        
        // Do not merge with result
        guard !connector.isResult(nodeID: leftID) && !connector.isResult(nodeID: rightID) else { return answer }
        
        // No merge without shared sensors
        //let (sharedSensors) = calcValues(left: leftNode, right: rightNode)
        let sharedSensors = leftNode.sensors(shared: rightNode.sensors())
        guard !sharedSensors.isEmpty else { return answer }
        
        // Create a new cell for the shared values
        let sharedNode = Node(sensors: sharedSensors)
        let sharedID = sharedNode.id
        nodeDict[sharedNode.id] = sharedNode
        answer = [sharedID]
        
        // Left and right nodes can't be root nodes any more
        // But only for level 0 nodes (no incoming)
        if connector.incoming(to: leftID).isEmpty {
            leftNode.isRoot = false
        }
        if connector.incoming(to: rightID).isEmpty {
            rightNode.isRoot = false
        }
        
        // Move all incoming toIDs for left/right to shared
        connector.moveAll(oldTo: leftID, newTo: sharedID)
        connector.moveAll(oldTo: rightID, newTo: sharedID)
        
        // remove shared sensors from left
        // left is gone -> shared gets the outgoing from left
        // otherwise shared connects to left
        leftNode.remove(sensors: sharedSensors)
        nodeDict[leftID] = leftNode
        if leftNode.isToBeRemoved() {
            connector.moveAll(oldFrom: leftID, newFrom: sharedID)
            remove(nodeID: leftID)
        } else {
            connector.connect(from: sharedID, to: leftID)
        }
        
        // remove shared sensors from right
        // right is gone -> shared gets the outgoing from right
        // otherwise shared connects to right
        rightNode.remove(sensors: sharedSensors)
        nodeDict[rightID] = rightNode
        if rightNode.isToBeRemoved() {
            connector.moveAll(oldFrom: rightID, newFrom: sharedID)
            remove(nodeID: rightID)
        } else {
            connector.connect(from: sharedID, to: rightID)
        }
        
        //        cleanUp()
        return answer
        
    }
    
    
    // MARK: Search
    
    func searchDFSAsyncBatch(sensors: [[Sensor]], tasks: Int) async -> [SearchResult] {
        let results = await withTaskGroup(of: [SearchResult].self) { group in
            
            let sensorHaps = sensors.splitInSubArrays(into: tasks)
            
            for ind in 0..<tasks {
                group.addTask {
                    return await self.searchDFSAsyncBatch(roots: self.rootNodeIDs(), sensors: sensorHaps[ind])
                }
            }
            
            var results = [SearchResult]()
            for await result in group {
                results.append(contentsOf: result)
            }
            return results
        }
        return results
    }
    
    
    func searchDFSAsyncBatch(roots: [UUID], sensors: [[Sensor]]) async -> [SearchResult] {
        var results: [SearchResult] = []
        for ind in 0..<(sensors.count) {
            var searchResult = SearchResult(search: sensors[ind], found: [], passed: 0)
            for rootID in roots {
                searchResult = searchResult.max(searchDFS(root: rootID, sensors: sensors[ind]))
                if searchResult.isComplete() {
                    break
                }
            }
            results.append(searchResult)
        }
        return results
    }
    
    func searchDFS(sensors: [Sensor]) -> SearchResult {
        var searchResult = SearchResult(search: sensors, found: [], passed: 0)
        for rootID in rootNodeIDs() {
            searchResult = searchResult.max(searchDFS(root: rootID, sensors: sensors))
            if searchResult.isComplete() {
                break
            }
        }
        return searchResult
    }
    
    
    func searchDFS(root: UUID, sensors: [Sensor]) -> SearchResult {
        
        var nodeStack = [root]
        var searchStack: [SearchResult] = []
        var finalResult = SearchResult(search: sensors, found: [], passed: 0)
        searchStack.append(finalResult)
        
        while !nodeStack.isEmpty {
            let currNode = nodeStack.removeLast()
            let currResult = searchStack.removeLast()
            if !(finalResult.isComplete() || finalResult.isEndOfPath()) {
                finalResult = searchCalc(nodeID: currNode, searchResult: currResult)
                for child in connector.outgoing(from: currNode) {
                    nodeStack.insert(child, at: 0)
                    searchStack.insert(finalResult, at: 0)
                }
            } else {
                break
            }
        }
        
        return finalResult
    }
    
    func searchCalc(nodeID: UUID, searchResult: SearchResult) -> SearchResult {
        
        // Update found values
        var found = searchResult.found
        var result = searchResult.result
        let search = searchResult.search
        var passed = searchResult.passed
        let sensors = nodeDict[nodeID]?.sensorDict.keys
        let aCell = nodeDict[nodeID]
        
        if !self.isResult(nodeID: nodeID) {
            for sensor in sensors! {
                passed += 1
                if !found.contains(sensor) && search.contains(sensor) {
                    found.append(sensor)
                }
            }
        } else {
            if (search.count == found.count) && (found.count == passed) {
                result = aCell?.sensorDict.keys.first
            }
        }
        
        return SearchResult(search: search ,found: found, passed: passed, result: result)
    }
    
    
    func isResult(nodeID: UUID) -> Bool {
            
            return !connector.has(from: nodeID)
        }

    
}
    
// MARK: Extension ARRAY

extension Array {
    func splitInSubArrays(into size: Int) -> [[Element]] {
        return (0..<size).map {
            stride(from: $0, to: count, by: size).map { self[$0] }
        }
    }
}

  


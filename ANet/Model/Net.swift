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
        let resultNode = Node(sensors: [result])
        nodeDict[resultNode.id] = resultNode
        connector.connect(from: node, to: resultNode)
    }

    // MARK: Merge
    
    
    func rootNodeIDs() -> [UUID] {
        var rootNodeIDs: [UUID] = []
        for uuid in nodeDict.keys {
            if connector.isRoot(nodeID: uuid) {
                rootNodeIDs.append(uuid)
            }
        }
        return rootNodeIDs
    }
    
    
    func remove(nodeID: UUID) {
        nodeDict.removeValue(forKey: nodeID)
        connector.remove(nodeID: nodeID)
    }
    
    
    func merge() {
        
        let nodeList = rootNodeIDs()
        
        var downInd = nodeList.count - 1
        let maxInd = (nodeList.count / 2) - 1
        
        for index in 0...maxInd {
            merge(left: nodeList[index], right: nodeList[downInd])
            downInd -= 1
        }
    }
    
    
    func merge(left leftID: UUID, right rightID: UUID) {
           
   //        guard !self.isRemoved() && !rightCell.isRemoved() else { return rootCells}
   //        guard !(self === rightCell) else { return rootCells}
           
           var leftNode = nodeDict[leftID]!
           var rightNode = nodeDict[rightID]!
           
           // Do not merge with result
            guard !connector.isResult(nodeID: leftID) && !connector.isResult(nodeID: rightID) else { return }
                  
           // No merge without shared sensors
           //let (sharedSensors) = calcValues(left: leftNode, right: rightNode)
           let sharedSensors = leftNode.sensors(shared: rightNode.sensors())
           guard !sharedSensors.isEmpty else { return }
       
           // Create a new cell for the shared values
           let sharedNode = Node(sensors: sharedSensors)
           let sharedID = sharedNode.id
           nodeDict[sharedNode.id] = sharedNode

           
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

       }

  
}

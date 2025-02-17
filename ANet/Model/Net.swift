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
    
    func populate(sensors: [Sensor], result: Sensor) {
        let node = Node(sensors: sensors)
        nodeDict[node.id] = node
        let resultNode = Node(sensors: [result])
        nodeDict[resultNode.id] = resultNode
        connector.connect(from: node, to: resultNode)
    }
    
}

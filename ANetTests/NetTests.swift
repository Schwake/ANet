//
//  NetTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 17.02.25.
//

import Testing

struct NetTests {

    //
    @Test func populateTest() async throws {
        let sevenSegments = SevenSegments()
        let sensors = sevenSegments.sensors(for: 0)
        let result = Sensor(position: 0)
        let net = Net()
        net.populate(sensors: sensors, result: result)
        
        #expect(net.nodeDict.keys.count == 2)
        #expect(net.nodeDict.values.count == 2)
        #expect(net.connector.fromDict.keys.count == 1)
        #expect(net.connector.toDict.keys.count == 1)
    }
    
    @Test func populateSevenSegmentsTest() async throws {
        
        let sevenSegments = SevenSegments()
        let net = Net()
        
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        
        #expect(net.nodeDict.keys.count == 20)
        #expect(net.nodeDict.values.count == 20)
        #expect(net.connector.fromDict.keys.count == 10)
        #expect(net.connector.toDict.keys.count == 10)
    }
    
    @Test func rootNodeIDsTest() async throws {
        let net = Net()
        let sensor1 = Sensor(position: 0)
        let sensor2 = Sensor(position: 1)
        let sensor3 = Sensor(position: 2)

        net.populate(sensors: [sensor1, sensor2], result: sensor3)
        #expect(net.rootNodeIDs().count == 1)
    }

    
    @Test func removeNodeIDTest() async throws {
        let net = Net()
        let sensor1 = Sensor(position: 0)
        let sensor2 = Sensor(position: 1)
        let sensor3 = Sensor(position: 2)
        
        net.populate(sensors: [sensor1, sensor2], result: sensor3)
        var nodeIDs = net.rootNodeIDs()
        #expect(nodeIDs.count == 1)
        net.remove(nodeID: nodeIDs[0])
        nodeIDs = net.rootNodeIDs()
        #expect(nodeIDs.count == 0)
        
    }
    
    
    @Test func mergeTests() async throws {
        
        let sensorA = Sensor(position: 1)
        let sensorB = Sensor(position: 2)
        let sensorC = Sensor(position: 3)
        let sensorD = Sensor(position: 4)
        let sensorE = Sensor(position: 5)
        let sensorF = Sensor(position: 6)
        let result0 = Sensor(position: 0)
        let result1 = Sensor(position: 1)
    
        // no shared sensors - nothing changes
        var net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorD, sensorE, sensorF], result: result1)
        var nodes = net1.rootNodeIDs()
        var node0 = nodes[0]
        var node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 2)
        #expect(net1.nodeDict[node0]?.sensors().count == 3)
        #expect(net1.nodeDict[node1]?.sensors().count == 3)
        #expect(net1.nodeDict.keys.count == 4)
        // two root nodes, each with a result node
        // node0 -> result0
        // node1 -> result1
        
        // left and right node do have unshared and shared sensors
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorD, sensorB, sensorE], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors() == [sensorB]) // Node with shared sensor will be new root node
        #expect(net1.nodeDict.keys.count == 5)
        // one root node, linked to two other nodes, each of which have a result
        // newNode -> node0
        // newNode -> node1
        // node0 -> result0
        // node1 -> result1
        
        // all of left node's sensors are shared with right node
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorA, sensorB, sensorC, sensorD, sensorE, sensorF], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorA))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorB))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorC))
        #expect(net1.nodeDict.keys.count == 4)
        // one root node, linked to one other nodes
        // newNode -> node1
        // newNode -> result0
        // node1 -> result1
        
        // all of right node's sensors are shared with left node
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC, sensorD, sensorE, sensorF], result: result0)
        net1.populate(sensors: [sensorD, sensorE, sensorF], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorD))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorE))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorF))
        #expect(net1.nodeDict.keys.count == 4)
        // one root node, linked to one other nodes
        // newNode -> node1
        // newNode -> result0
        // node1 -> result1
        
    }
    
}

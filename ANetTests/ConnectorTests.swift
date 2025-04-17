//
//  ConnectorTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 17.02.25.
//

import Testing

struct ConnectorTests {

    @Test func hasConnectionTest() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.hasConnection(from: nodeFrom, to: nodeTo))
        #expect(!connector.hasConnection(from: nodeTo, to: nodeFrom))
    }
    
    @Test func isResultTest() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(!connector.isResult(nodeID: nodeFrom.id))
        #expect(connector.isResult(nodeID: nodeTo.id))
    }
    
    @Test func isRootTest() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        connector.connect(from: nodeFrom, to: nodeTo)
        // A node is always root node after creation, this changes only with a merge!
        #expect(nodeFrom.isRoot)
        #expect(nodeTo.isRoot)
//        #expect(connector.isRoot(nodeID: nodeFrom.id))
//        #expect(!connector.isRoot(nodeID: nodeTo.id))
    }
    
    @Test func removeNodeIDTest() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        connector.connect(from: nodeFrom, to: nodeTo)
        connector.remove(nodeID: nodeTo.id)
        #expect(!connector.hasConnection(from: nodeFrom, to: nodeTo))
    }
    
    @Test func connectFromToTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.hasConnection(from: nodeFrom, to: nodeTo))
    }
    
    @Test func connectFromIDToIDTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom.id, to: nodeTo.id)
        #expect(connector.hasConnection(from: nodeFrom, to: nodeTo))
    }
    
    @Test func hasFromNodeToNodeTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.has(from: nodeFrom, to: nodeTo))
    }
    
    @Test func hasToNodeFromNodeTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.has(to: nodeTo, from: nodeFrom))
    }
    
    @Test func hasFromTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.has(from: nodeFrom.id))
    }
    
    @Test func hasToTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])

        connector.connect(from: nodeFrom, to: nodeTo)
        #expect(connector.has(to: nodeTo.id))
    }

    @Test func outgoingFromTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        let nodeTo2 = Node(sensors: [Sensor(position: 3)])
        
        connector.connect(from: nodeFrom, to: nodeTo)
        connector.connect(from: nodeFrom, to: nodeTo2)
        #expect(connector.outgoing(from: nodeFrom.id).contains(nodeTo.id))
        #expect(connector.outgoing(from: nodeFrom.id).contains(nodeTo2.id))
        #expect(connector.outgoing(from: nodeFrom.id).count == 2)
    }
    
    
    @Test func moveAllOldToNewToTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 0)])
        let nodeFrom2 = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        let nodeTo2 = Node(sensors: [Sensor(position: 3)])
        
        connector.connect(from: nodeFrom, to: nodeTo)
        connector.connect(from: nodeFrom2, to: nodeTo)
        connector.moveAll(oldTo: nodeTo.id, newTo: nodeTo2.id)
        
        #expect(connector.outgoing(from: nodeFrom.id).contains(nodeTo2.id))
        #expect(!connector.outgoing(from: nodeFrom.id).contains(nodeTo.id))
        #expect(connector.outgoing(from: nodeFrom2.id).contains(nodeTo2.id))
        #expect(!connector.outgoing(from: nodeFrom2.id).contains(nodeTo.id))
        #expect(connector.outgoing(from: nodeFrom.id).count == 1)
        #expect(connector.outgoing(from: nodeFrom2.id).count == 1)
        #expect(!connector.incoming(to: nodeTo.id).contains(nodeFrom.id))
        #expect(connector.incoming(to: nodeTo2.id).contains(nodeFrom.id))
        #expect(!connector.incoming(to: nodeTo.id).contains(nodeFrom2.id))
        #expect(connector.incoming(to: nodeTo2.id).contains(nodeFrom2.id))
        #expect(connector.incoming(to: nodeTo.id).count == 0)
        #expect(connector.incoming(to: nodeTo2.id).count == 2)
    }
    
    @Test func moveFromOldToNewToTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        let nodeTo2 = Node(sensors: [Sensor(position: 3)])
        
        connector.connect(from: nodeFrom, to: nodeTo)
        connector.move(from: nodeFrom.id, oldTo: nodeTo.id, newTo: nodeTo2.id)
        #expect(connector.outgoing(from: nodeFrom.id).contains(nodeTo2.id))
        #expect(!connector.outgoing(from: nodeFrom.id).contains(nodeTo.id))
        #expect(!connector.incoming(to: nodeTo.id).contains(nodeFrom.id))
        #expect(connector.incoming(to: nodeTo2.id).contains(nodeFrom.id))
        #expect(connector.outgoing(from: nodeFrom.id).count == 1)
        #expect(connector.incoming(to: nodeTo.id).count == 0)
        #expect(connector.incoming(to: nodeTo2.id).count == 1)
    }
    
    
    @Test func moveAllOldFromNewFromTests() async throws {
        let connector = Connector()
        let nodeFrom = Node(sensors: [Sensor(position: 0)])
        let nodeFrom2 = Node(sensors: [Sensor(position: 1)])
        let nodeTo = Node(sensors: [Sensor(position: 2)])
        let nodeTo2 = Node(sensors: [Sensor(position: 3)])
        
        connector.connect(from: nodeFrom, to: nodeTo)
        connector.connect(from: nodeFrom, to: nodeTo2)
        connector.moveAll(oldFrom: nodeFrom.id, newFrom: nodeFrom2.id)
        #expect(connector.outgoing(from: nodeFrom.id).count == 0)
        #expect(connector.outgoing(from: nodeFrom2.id).contains(nodeTo.id))
        #expect(connector.outgoing(from: nodeFrom2.id).contains(nodeTo2.id))
        #expect(connector.outgoing(from: nodeFrom2.id).count == 2)
    }
    
    
    @Test func pathForTests() {
        
        let net = Net()
        let sensor1: Sensor = Sensor(position: 1)
        let sensor2: Sensor = Sensor(position: 2)
        let sensor3: Sensor = Sensor(position: 3)
        let sensor4: Sensor = Sensor(position: 4)
        let sensor5: Sensor = Sensor(position: 5)
        let sensor6: Sensor = Sensor(position: 6)
        let sensor7: Sensor = Sensor(position: 7)
        let sensor8: Sensor = Sensor(position: 8)
        let sensorResult1: Sensor = Sensor(position: 1)
        let sensorResult2: Sensor = Sensor(position: 2)
        let sensorResult3: Sensor = Sensor(position: 3)
        
        let node1 = Node(sensors: [sensor1, sensor2, sensor3, sensor4])
        let node2 = Node(sensors: [sensor3, sensor4, sensor5, sensor6])
        let node3 = Node(sensors: [sensor5, sensor6, sensor7, sensor8])
        var result1 = Node(sensors: [sensorResult1])
        result1.isRoot = false
        var result2 = Node(sensors: [sensorResult2])
        result2.isRoot = false
        var result3 = Node(sensors: [sensorResult3])
        result3.isRoot = false
        
        net.nodeDict[node1.id] = node1
        net.nodeDict[node2.id] = node2
        net.nodeDict[node3.id] = node3
        net.nodeDict[result1.id] = result1
        net.nodeDict[result2.id] = result2
        net.nodeDict[result3.id] = result3
        net.connector.connect(from: node1.id, to: result1.id)
        net.connector.connect(from: node2.id, to: result2.id)
        net.connector.connect(from: node3.id, to: result3.id)
        
        let crawler = Crawler()
        var netInfo = crawler.info(net: net)
        var dotString = crawler.toDot7Segment(net: net)
        //        crawler.visualize(content: dotString)
        
        #expect(netInfo.nodes == 6)
        #expect(netInfo.incoming == 3)
        #expect(netInfo.outgoing == 3)
        #expect(netInfo.roots == 3)
        #expect(netInfo.results == 3)
        #expect(netInfo.depth == 1)
        
        net.merge(left: node1.id, right: node2.id)
        
        let rootNodes = net.rootNodeIDs()
        let path = net.connector.pathFor(nodeID: rootNodes[0])
        print("Path size: \(path.count) ")
        
        // Content of 0,1 might switch - rerun and check again
        net.mergeComplex(left: rootNodes[0], right: rootNodes[1])
        dotString = crawler.toDot7Segment(net: net)
        crawler.visualize(content: dotString)
        netInfo = crawler.info(net: net)
        
        #expect(netInfo.nodes == 7)
        #expect(netInfo.incoming == 6)
        #expect(netInfo.outgoing == 6)
        #expect(netInfo.roots == 2)
        #expect(netInfo.results == 3)
        #expect(netInfo.depth == 3)
        
    }
   
}

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
        #expect(connector.isRoot(nodeID: nodeFrom.id))
        #expect(!connector.isRoot(nodeID: nodeTo.id))
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
        #expect(connector.outgoing(from: nodeFrom.id).count == 1)
        #expect(connector.outgoing(from: nodeFrom2.id).contains(nodeTo2.id))
        #expect(connector.outgoing(from: nodeFrom2.id).count == 1)
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
        #expect(connector.outgoing(from: nodeFrom.id).count == 1)

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
    
    
   
}

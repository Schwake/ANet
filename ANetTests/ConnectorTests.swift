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

}

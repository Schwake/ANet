//
//  NodeTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 17.02.25.
//

import Testing

struct NodeTests {

    // Also tests has(sensor:)
    @Test func initTests() async throws {
        
        var sensors : [Sensor] = []
        sensors.append(Sensor(position: 1))
        sensors.append(Sensor(position: 2))
        sensors.append(Sensor(position: 3))
        sensors.append(Sensor(position: 4))

        let node = Node(sensors: sensors)
        #expect(!node.has(sensor: Sensor(position: 0)))
        #expect(node.has(sensor: sensors[0]))
        #expect(node.has(sensor: sensors[1]))
        #expect(node.has(sensor: sensors[2]))
        #expect(node.has(sensor: sensors[3]))
        #expect(!node.has(sensor:Sensor(position: 5)))
        
    }


    
}

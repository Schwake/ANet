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
    
    // MARK: Merge
    
    @Test func sensorsSharedTests() throws {
        
        let sensorValueA = Sensor(position: 1)
        let sensorValueB = Sensor(position: 2)
        let sensorValueC = Sensor(position: 3)
        let sensorValueD = Sensor(position: 4)
        let sensorValueF = Sensor(position: 6)
        
        let node1 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        let node2 = Node(sensors: [sensorValueD, sensorValueB, sensorValueF])
        
        let (sharedSensors) = node1.sensors(shared: node2.sensors())
        #expect(sharedSensors == [sensorValueB])
    }

    
    @Test func sensorsUnsharedTests() throws {
        
        let sensorValueA = Sensor(position: 1)
        let sensorValueB = Sensor(position: 2)
        let sensorValueC = Sensor(position: 3)
        let sensorValueD = Sensor(position: 4)
        let sensorValueF = Sensor(position: 6)
        
        let node1 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        let node2 = Node(sensors: [sensorValueD, sensorValueB, sensorValueF])
        
        let (unsharedSensors1) = node1.sensors(unshared: node2.sensors())
        #expect(unsharedSensors1.contains(sensorValueD))
        #expect(unsharedSensors1.contains(sensorValueF))

        
        let (unsharedSensors2) = node2.sensors(unshared: node1.sensors())
        #expect(unsharedSensors2.contains(sensorValueA))
        #expect(unsharedSensors2.contains(sensorValueC))
    }


    @Test func removeSensorsTests() throws {
        let sensorValueA = Sensor(position: 1)
        let sensorValueB = Sensor(position: 2)
        let sensorValueC = Sensor(position: 3)
        
        var node1 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        var node2 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        var node3 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        var node4 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        
        node1.remove(sensors: [sensorValueA])
        let sensors1 = node1.sensors()
        #expect(sensors1.count == 2)
        #expect(sensors1.contains(sensorValueB))
        #expect(sensors1.contains(sensorValueC))
        
        node2.remove(sensors: [sensorValueA, sensorValueB, sensorValueC])
        let sensors2 = node2.sensors()
        #expect(sensors2.count == 0)

        node3.remove(sensors: [sensorValueC])
        let sensors3 = node3.sensors()
        #expect(sensors3.count == 2)
        #expect(sensors3.contains(sensorValueA))
        #expect(sensors3.contains(sensorValueB))
        
        node4.remove(sensors: [])
        let sensors4 = node4.sensors()
        #expect(sensors4.count == 3)
        #expect(sensors4.contains(sensorValueA))
        #expect(sensors4.contains(sensorValueB))
        #expect(sensors4.contains(sensorValueC))
    }
    
    
    @Test func isToBeREmovedTests() throws {
        
        let sensorValueA = Sensor(position: 1)
        let sensorValueB = Sensor(position: 2)
        let sensorValueC = Sensor(position: 3)
        
        var node1 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        #expect(node1.isToBeRemoved() == false)
        node1.remove(sensors: [sensorValueA, sensorValueB, sensorValueC])
        #expect(node1.isToBeRemoved())
    }
    
    
    @Test func sensorsTests() throws {
        let sensorValueA = Sensor(position: 1)
        let sensorValueB = Sensor(position: 2)
        let sensorValueC = Sensor(position: 3)
        
        let node1 = Node(sensors: [sensorValueA, sensorValueB, sensorValueC])
        let sensors1 = node1.sensors()
        #expect(sensors1.contains(sensorValueA))
        #expect(sensors1.contains(sensorValueB))
        #expect(sensors1.contains(sensorValueC))
    }
    
}

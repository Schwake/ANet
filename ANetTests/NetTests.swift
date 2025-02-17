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

}

//
//  SensorTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 17.02.25.
//

import Testing

struct SensorTests {

    @Test func as7SegmentTest() async throws {
        
        let segmentDict = [1 : "A", 2 : "B", 3 : "C", 4 : "D", 5 : "E", 6 : "F", 7 : "G"]
            
        for index in 0..<9 {
            let sensor = Sensor(position: index)
            if index == 0 || index == 8 {
                #expect(sensor.as7Segment() == "X")
            } else {
                #expect(sensor.as7Segment() == segmentDict[index]!)
            }
        } 
    }

}

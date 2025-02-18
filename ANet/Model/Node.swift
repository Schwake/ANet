//
//  Node.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import Foundation

struct Node {
    
    let id = UUID()
    var sensorDict: [Sensor: Bool] = [:]
    
    init(sensors: [Sensor]) {
        for sensor in sensors {
            sensorDict[sensor] = true
        }
    }
    
    
    func has(sensor: Sensor) -> Bool {
        return sensorDict[sensor] ?? false
    }
    
    
    func sensorsAs7Segment() -> String {
        var toString = String()
        for sensor in sensorDict.keys {
            toString += "\(sensor.as7Segment())"
        }
        return toString
    }
    
    func sensorsAsString() -> String {
        var toString = String()
        for sensor in sensorDict.keys {
            toString += "\(sensor.asString())"
        }
        return toString
    }
    
}

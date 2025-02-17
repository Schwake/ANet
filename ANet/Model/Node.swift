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
    
}

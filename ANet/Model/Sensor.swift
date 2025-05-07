//
//  Sensor.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import Foundation

struct Sensor: Hashable, Codable {
    
    let position: Int
    
    static let segmentsDict = [1 : "A", 2 : "B", 3 : "C", 4 : "D", 5 : "E", 6 : "F", 7 : "G"]
    
    
    func asString() -> String {
        return "\(position)"
    }
    
    
    func as7Segment() -> String {
        return Sensor.segmentsDict[position] ?? "X"
    }
    
}

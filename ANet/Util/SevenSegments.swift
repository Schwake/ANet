//
//  SevenSegments.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import Foundation

struct SevenSegments {
    
    var digitsDict = [Int:[Int]]()

    init() {
        // A - B - C - D - E - F - G
        // 1 - 2 - 3 - 4 - 5 - 6 - 7
        digitsDict[0] = [1, 2, 3, 4, 5, 6]
        digitsDict[1] = [2, 3]
        digitsDict[2] = [1, 2, 7, 5, 4]
        digitsDict[3] = [1, 2, 7, 3, 4]
        digitsDict[4] = [6, 7, 2, 3]
        digitsDict[5] = [1, 6, 7, 3, 4]
        digitsDict[6] = [1, 6, 7, 5, 3, 4]
        digitsDict[7] = [1, 2, 3]
        digitsDict[8] = [1, 2, 3, 4, 5, 6, 7]
        digitsDict[9] = [1, 2, 3, 4, 6, 7]
    }
    
    // Answer a set of sensors with input corresponding to the seven segment positions for the given digit
    func sensors(for digit: Int) -> [Sensor] {
        
        var sensors: [Sensor] = []
        if let values = digitsDict[digit] {
            for item in values {
                sensors.append(Sensor(position: item))
            }
        }
    
        return sensors
    }
    

}


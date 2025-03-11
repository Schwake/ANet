//
//  Labels.swift
//  VeryNet
//
//  Created by Gregor Schwake on 11/01/2024.
//

import Foundation

// From MNIST
public struct Labels {
    
    var magicNumber: Int        // 2051
    var numberOfRecords: Int    // 10.000 test, 60.000 training
    var labels: [Int]           // 0 - 9
    
    
    public func split(parts: Int) -> [Labels] {
        var answer = [Labels]()
        let subsection = labels.count / parts
        var startIndex = 0
        for _ in 1...parts {
            var labelsNew = [Int]()
            for index in startIndex...(startIndex + subsection - 1) {
                labelsNew.append(labels[index])
            }
            let idx1Labels = Labels(magicNumber: magicNumber,
                                        numberOfRecords: numberOfRecords / parts,
                                        labels: labelsNew)
            answer.append(idx1Labels)
            startIndex = startIndex + subsection
        }
        
        if (numberOfRecords - startIndex) > 0 {
            var labelsNew = [Int]()
            for index in startIndex...(numberOfRecords - 1) {
                labelsNew.append(labels[index])
            }
            let idx1Labels = Labels(magicNumber: magicNumber,
                                        numberOfRecords: numberOfRecords - startIndex,
                                        labels: labelsNew)
            answer.append(idx1Labels)
        }
        return answer
    }
    
    
    func asSensors() -> [Sensor] {
        var sensors: [Sensor] = []
        for labelInd in 0...(labels.count - 1) {
            sensors.append(Sensor(position: labels[labelInd]))
        }
        return sensors
    }

    
}

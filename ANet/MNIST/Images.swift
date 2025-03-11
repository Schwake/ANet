//
//  Images.swift
//  GregNet
//
//  Created by Greg Schwake on 13/12/2024.
//

import Foundation

// From MNIST
public struct Images {
    
    var magicNumber: Int         // 2051
    var numberOfRecords: Int     // 10.000 test, 60.000 training
    var numberOfRows: Int        // per image 28
    var numberOfColumns: Int     // per image 28
    var images: [[[Int]]]          // 10.000 or 60.000, each image with 28 * 28 pixels
    
    
    public func split(parts: Int) -> [Images] {
        var answer = [Images]()
        let subsection = images.count / parts
        var startIndex = 0
        for _ in 1...parts {
            var imagesNew = [[[Int]]]()
            for index in startIndex...(startIndex + subsection - 1) {
                imagesNew.append(images[index])
            }
            let idx3Images = Images(magicNumber: magicNumber,
                                        numberOfRecords: numberOfRecords / parts,
                                        numberOfRows: 28,
                                        numberOfColumns: 28,
                                        images: imagesNew)
            answer.append(idx3Images)
            startIndex = startIndex + subsection
        }
        if (numberOfRecords - startIndex) > 0 {
            var imagesNew = [[[Int]]]()
            for index in startIndex...(numberOfRecords - 1) {
                imagesNew.append(images[index])
            }
            let idx3Images = Images(magicNumber: magicNumber,
                                        numberOfRecords: numberOfRecords - startIndex,
                                        numberOfRows: 28,
                                        numberOfColumns: 28,
                                        images: imagesNew)
            answer.append(idx3Images)
        }
        
        return answer
    }

    
    public mutating func limitImagePixel() {
        
        for imageInd in 0...(images.count - 1) {
            for rowInd in 0...27 {
                for colInd in 0...27 {
                    if images[imageInd][rowInd][colInd] > 1 {
                        images[imageInd][rowInd][colInd] = 1
                    }
                }
            }
        }
    }
    
    func asSensors() -> [[Sensor]] {
        var sensors: [[Sensor]] = []
        
        for imageInd in 0...(images.count - 1) {
            var position = 0
            var imageSensors: [Sensor] = []
            for rowInd in 0...27 {
                for colInd in 0...27 {
                    position += 1
                    if images[imageInd][rowInd][colInd] == 1 {
                        imageSensors.append(Sensor(position: position))
                    }
                }
            }
            sensors.append(imageSensors)
        }
        return sensors
    }
    
}


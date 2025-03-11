//
//  ImportExport.swift
//  VeryNet
//
//  Created by Gregor Schwake on 11/01/2024.
//

import Foundation

public class ImportExport {

    
    // MARK: SaveToInternal
    
    // Read files in MNIST format and save them as CSV
    public  func saveToInternal() async {
        
        await saveToInternal(labelPathTest: "/Users/greg/Documents/mnist/t10k-labels-idx1-ubyte",
                             labelFileTest: "idx1Label-test.txt",
                             labelPathTrain: "/Users/greg/Documents/mnist/train-labels-idx1-ubyte",
                             labelFileTrain: "idx1Label-train.txt",
                             imagePathTest: "/Users/greg/Documents/mnist/t10k-images-idx3-ubyte",
                             imageFileTest: "idx3Image-test.txt",
                             imagePathTrain: "/Users/greg/Documents/mnist/train-images-idx3-ubyte",
                             imageFileTrain: "idx3Image-train.txt")
    }
    
    
    // MARK: Load MNIST
    
    // Read file MNIST labels and answer a struct containing them
    public  func loadLabels(path: String) -> Labels {
        
        let path = path
        let fileHandle = FileHandle(forReadingAtPath: path)
        
        // First 4 bytes magic number
        let source = fileHandle!.readData(ofLength: 4)
        var bigEndianUInt32 = source.withUnsafeBytes { $0.load(as: UInt32.self) }
        let magicNumber = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        // Second 4 bytes number of records
        let source2 = fileHandle!.readData(ofLength: 4)
        bigEndianUInt32 = source2.withUnsafeBytes { $0.load(as: UInt32.self) }
        let noOfRecords = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        // Data - unsigned byte
        // noOfRecords labels
        var labels = [Int]()
        for _ in 1...noOfRecords {
            let aByte = fileHandle!.readData(ofLength: 1)
            
            let bigEndianUInt8 = aByte.withUnsafeBytes { $0.load(as: UInt8.self) }
            
            let aNumber = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
            ? UInt8(bigEndian: bigEndianUInt8)
            : bigEndianUInt8
            
            let array : [UInt8] = [0, 0, 0, aNumber]
            var anInt : Int = 0
            for byte in array {
                anInt = anInt << 8
                anInt = anInt | Int(byte)
            }
            
            labels.append(anInt)
        }
        
        let idx1Labels = Labels(magicNumber: Int(magicNumber), numberOfRecords: Int(noOfRecords), labels: labels)
        
        return idx1Labels
    }
    
    
    // Read file MNIST images and answer a struct containing them
    public  func loadImages(path: String) -> Images {
        
        let path = path
        let fileHandle = FileHandle(forReadingAtPath: path)
        
        // First 4 bytes magic number
        let source = fileHandle!.readData(ofLength: 4)
        var bigEndianUInt32 = source.withUnsafeBytes { $0.load(as: UInt32.self) }
        let magicNumber = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        // Second 4 bytes number of recors
        let source2 = fileHandle!.readData(ofLength: 4)
        bigEndianUInt32 = source2.withUnsafeBytes { $0.load(as: UInt32.self) }
        let noOfRecords = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        // Third 4 bytes number of rows
        let source3 = fileHandle!.readData(ofLength: 4)
        bigEndianUInt32 = source3.withUnsafeBytes { $0.load(as: UInt32.self) }
        let noOfRows = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        // Fourth 4 bytes number of columns
        let source4 = fileHandle!.readData(ofLength: 4)
        bigEndianUInt32 = source4.withUnsafeBytes { $0.load(as: UInt32.self) }
        let noOfColumns = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        ? UInt32(bigEndian: bigEndianUInt32)
        : bigEndianUInt32
        
        
        // Data - unsigned byte
        var images = [[[Int]]]()
        var image = [[Int]]()
        var rowIndex = 1
        var aRow = [Int]()
        
        for _ in 1...noOfRecords {
            for _ in 1...784 {
                let aByte = fileHandle!.readData(ofLength: 1)
                
                let bigEndianUInt8 = aByte.withUnsafeBytes { $0.load(as: UInt8.self) }
                let aPixel = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
                ? UInt8(bigEndian: bigEndianUInt8)
                : bigEndianUInt8
                
                let array : [UInt8] = [0, 0, 0, aPixel]
                var anInt : Int = 0
                for byte in array {
                    anInt = anInt << 8
                    anInt = anInt | Int(byte)
                }
                
                // collect all items row for row and add them to the image
                aRow.append(anInt)
                if rowIndex < 28 {
                    rowIndex += 1
                } else {
                    image.append(aRow)
                    aRow = [Int]()
                    rowIndex = 1
                }
            }
            
            images.append(image)
            image = [[Int]]()
        }
        
        var idx3Images = Images(magicNumber: Int(magicNumber), numberOfRecords: Int(noOfRecords), numberOfRows: Int(noOfRows), numberOfColumns: Int(noOfColumns), images: images)
        
        idx3Images.limitImagePixel()
        
        return idx3Images
    }
    
    // MARK: Save local
    
    // Save Idx1 label struct to given file
    // magicNumber,numberOfRecords,label1,...,labeln
    public  func saveLabels(file: String, labels: Labels) {
        
        let idx1Labels = labels
        
        var stringToWrite = String()
        
        stringToWrite += " \(idx1Labels.magicNumber),\(idx1Labels.numberOfRecords)"
        
        for label in idx1Labels.labels {
            stringToWrite += ",\(label)"
        }
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try stringToWrite.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Save Idx3 Image struct to given file
    // magicNumber,numberOfRecords,numberOfRows, numberOfColumns, pixel1,...,pixeln
    public  func saveImages(file: String, images: Images) {
        
        let idx3Images = images
        
        var stringToWrite = String()
        
        stringToWrite += " \(idx3Images.magicNumber),\(idx3Images.numberOfRecords)"
        stringToWrite += ",\(idx3Images.numberOfRows),\(idx3Images.numberOfColumns)"
        
        for image in idx3Images.images {
            for row in image {
                for pixel in row {
                    stringToWrite += ",\(pixel)"
                }
            }
        }
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try stringToWrite.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
      public func saveToInternal(labelPathTest: String, labelFileTest: String, labelPathTrain: String, labelFileTrain: String, imagePathTest: String, imageFileTest: String, imagePathTrain: String, imageFileTrain: String ) async {
        
        async let anIdx1LabelTest =  ImportExport().loadLabels(path: labelPathTest)
        async let anIdx1LabelTrain = ImportExport().loadLabels(path: labelPathTrain)
        async let anIdx3ImageTest = ImportExport().loadImages(path: imagePathTest)
        async let anIdx3ImageTrain = ImportExport().loadImages(path: imagePathTrain)
        
        ImportExport().saveLabels(file: labelFileTest , labels:  await anIdx1LabelTest)
        ImportExport().saveLabels(file: labelFileTrain, labels: await anIdx1LabelTrain)
        ImportExport().saveImages(file: imageFileTest, images: await anIdx3ImageTest)
        ImportExport().saveImages(file: imageFileTrain, images: await anIdx3ImageTrain)
    }
    
    
    // MARK: Load local
    
    public func loadSavedImages(tasks: Int, file: String) async -> Images {
        
        var contentFromFile = String()
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            contentFromFile = try String(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
        
        let items = contentFromFile.components(separatedBy: ",")
        let magicNumber = 2051
        let numberOfRecords = Int(items[1])!
        let numberOfRows = Int(items[2])
        let numberOfColumns = Int(items[3])
        
        var itemArray = [[String]]()
        let step = ((items.count - 4) / tasks)
        var start = 4
        var end = step + 3
        
        for index in 0...(tasks - 1) {
            if index == (tasks - 1) { end = items.count - 1}
            itemArray.append(Array(items[start...end]))
            
            start = end + 1
            if index == (tasks - 2) {
                end += step
            } else {
                if index != (tasks - 1) {
                    end += step
                }
            }
        }
        
        let images = await withTaskGroup(of: [Int:[[[Int]]]].self) { group -> [[[Int]]] in
            
            for (index,item) in itemArray.enumerated() {
                group.addTask { [self] in await self.loadImages(order: index, items: item) }
            }
            
            var collectedImages = [[Int: [[[Int]]]]]()
            
            for await value in group {
                collectedImages.append(value)
            }
            
            var sortedKeys = [Int]()
            for item in collectedImages {
                for aKey in item.keys {
                    sortedKeys.append(aKey)
                }
            }
            sortedKeys = sortedKeys.sorted()
            var answerImages = [[[Int]]]()
            
            for sortedKey in sortedKeys {
                for item in collectedImages {
                    for aKey in item.keys {
                        if sortedKey == aKey {
                            answerImages = answerImages + item[aKey]!
                        }
                    }
                }
            }
            return answerImages
            
        }
        
        var anIdx3Images = Images(magicNumber: magicNumber, numberOfRecords: numberOfRecords, numberOfRows: numberOfRows!, numberOfColumns: numberOfColumns!, images: images)
        
        
        anIdx3Images.limitImagePixel()
        return anIdx3Images
    }
    
    
    private func loadImages(order: Int, items: [String]) async -> [Int:[[[Int]]]] {
        let order = order
        let items = items
        var images = [[[Int]]]()
        var image = [[Int]]()
        
        var aRow = [Int]()
        
        for index in 0...(items.count - 1) {
            
            aRow.append(Int(items[index])!)
            
            if aRow.count == 28 {
                image.append(aRow)
                aRow = [Int]()
            }
            
            if image.count == 28 {
                images.append(image)
                image = [[Int]]()
            }
            
        }
        
        return [order:images]
        
    }
    
    
    
    public func loadSavedLabels(file: String) -> Labels {
         
        let file = file
        var contentFromFile = String()
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            contentFromFile = try String(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
        
        let items = contentFromFile.components(separatedBy: ",")
        let magicNumber = 2049
        let numberOfRecords = Int(items[1])
        var labels = [Int]()
        
        for index in 2...(items.count - 1) {
            labels.append(Int(items[index])!)
        }
        
        let answer = Labels(magicNumber: magicNumber, numberOfRecords: numberOfRecords!, labels: labels)
        return answer
    }
    
    //
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }

}

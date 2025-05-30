//
//  NetTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 17.02.25.
//

import Testing
import Foundation

struct NetTests {

    
    // MARK: Populate
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
    
    
    // rootNodeIDs - isResult - rootCount
    @Test func testSeveral() async throws {
        let sevenSegments = SevenSegments()
        let net = Net()
        
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        
        #expect(net.rootNodeIDs().count == 10)
        
        for id in net.connector.toDict.keys {
            #expect(net.isResult(nodeID: id))
        }
        
    }
    
    
    // MARK: Merge
    
    @Test func rootNodeIDsTest() async throws {
        let net = Net()
        let sensor1 = Sensor(position: 0)
        let sensor2 = Sensor(position: 1)
        let sensor3 = Sensor(position: 2)

        net.populate(sensors: [sensor1, sensor2], result: sensor3)
        #expect(net.rootNodeIDs().count == 1)
    }

    
    @Test func removeNodeIDTest() async throws {
        let net = Net()
        let sensor1 = Sensor(position: 0)
        let sensor2 = Sensor(position: 1)
        let sensor3 = Sensor(position: 2)
        
        net.populate(sensors: [sensor1, sensor2], result: sensor3)
        var nodeIDs = net.rootNodeIDs()
        #expect(nodeIDs.count == 1)
        net.remove(nodeID: nodeIDs[0])
        nodeIDs = net.rootNodeIDs()
        #expect(nodeIDs.count == 0)
        
    }
    
    
    @Test func mergeTypesTests() async throws {
        
        let sensorA = Sensor(position: 1)
        let sensorB = Sensor(position: 2)
        let sensorC = Sensor(position: 3)
        let sensorD = Sensor(position: 4)
        let sensorE = Sensor(position: 5)
        let sensorF = Sensor(position: 6)
        let result0 = Sensor(position: 0)
        let result1 = Sensor(position: 1)
    
        // no shared sensors - nothing changes
        var net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorD, sensorE, sensorF], result: result1)
        var nodes = net1.rootNodeIDs()
        var node0 = nodes[0]
        var node1 = nodes[1]
        net1.merge(left: node0, right: node1)

        #expect(net1.rootNodeIDs().count == 2)
        #expect(net1.nodeDict[node0]?.sensors().count == 3)
        #expect(net1.nodeDict[node1]?.sensors().count == 3)
        #expect(net1.nodeDict.keys.count == 4)
        // two root nodes, each with a result node
        // node0 -> result0
        // node1 -> result1
        var netInfo = Crawler().info(net: net1)
        #expect(netInfo.nodes == 4)
        #expect(netInfo.results == 2)
        #expect(netInfo.roots == 2)
        #expect(netInfo.incoming == 2)
        #expect(netInfo.outgoing == 2)
        #expect(netInfo.depth == 1)

        // left and right node do have unshared and shared sensors
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorD, sensorB, sensorE], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors() == [sensorB]) // Node with shared sensor will be new root node
        #expect(net1.nodeDict.keys.count == 5)
        // one root node, linked to two other nodes, each of which have a result
        // newNode -> node0
        // newNode -> node1
        // node0 -> result0
        // node1 -> result1
        netInfo = Crawler().info(net: net1)
        #expect(netInfo.nodes == 5)
        #expect(netInfo.results == 2)
        #expect(netInfo.roots == 1)
        #expect(netInfo.incoming == 4)
        #expect(netInfo.outgoing == 4)
        #expect(netInfo.depth == 2)
        
        // all of left node's sensors are shared with right node
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC], result: result0)
        net1.populate(sensors: [sensorA, sensorB, sensorC, sensorD, sensorE, sensorF], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorA))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorB))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorC))
        #expect(net1.nodeDict.keys.count == 4)
        // one root node, linked to one other nodes
        // newNode -> node1
        // newNode -> result0
        // node1 -> result1
        netInfo = Crawler().info(net: net1)
        #expect(netInfo.nodes == 4)
        #expect(netInfo.results == 2)
        #expect(netInfo.roots == 1)
        #expect(netInfo.incoming == 3)
        #expect(netInfo.outgoing == 3)
        #expect(netInfo.depth == 2)
        
        // all of right node's sensors are shared with left node
        net1 = Net()
        net1.populate(sensors: [sensorA, sensorB, sensorC, sensorD, sensorE, sensorF], result: result0)
        net1.populate(sensors: [sensorD, sensorE, sensorF], result: result1)
        nodes = net1.rootNodeIDs()
        node0 = nodes[0]
        node1 = nodes[1]
        net1.merge(left: node0, right: node1)
        
        #expect(net1.rootNodeIDs().count == 1) // Node with sensorB
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorD))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorE))
        #expect(net1.nodeDict[net1.rootNodeIDs()[0]]!.sensors().contains(sensorF))
        #expect(net1.nodeDict.keys.count == 4)
        // one root node, linked to one other nodes
        // newNode -> node1
        // newNode -> result0
        // node1 -> result1
        netInfo = Crawler().info(net: net1)
        #expect(netInfo.nodes == 4)
        #expect(netInfo.results == 2)
        #expect(netInfo.roots == 1)
        #expect(netInfo.incoming == 3)
        #expect(netInfo.outgoing == 3)
        #expect(netInfo.depth == 2)
        
    }
    
    
    
    @Test func testMerge61() {
         
         let sevenSegments = SevenSegments()
         let net = Net()
         var sensorDict: [Int : [Sensor]] = [:]
         
         let indices = [6,1]
         for ind in indices {
             let sensors = sevenSegments.sensors(for: ind)
             sensorDict[ind] = sensors
             let result = Sensor(position: ind)
             net.populate(sensors: sensors, result: result)
         }
         
         net.merge()
         
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        
//        crawler.visualize(content: dotString)

        let netInfo = crawler.info(net: net)

        let info = netInfo.toString()
        print(info)

         #expect(netInfo.nodes == 5)
         #expect(netInfo.incoming == 4)
         #expect(netInfo.outgoing == 4)
         #expect(netInfo.depth == 2)
         #expect(netInfo.results == 2)
         #expect(netInfo.roots == 1)


     }

     
     @Test func testMerge639() {
         
         let sevenSegments = SevenSegments()
         let net = Net()
         
         let indices = [6,3]
         for ind in indices {
             let sensors = sevenSegments.sensors(for: ind)
             let result = Sensor(position: ind)
             net.populate(sensors: sensors, result: result)
         }
         
         net.merge()
         
         let sensors2 = sevenSegments.sensors(for: 9)
         let result2 = Sensor(position: 9)
         net.populate(sensors: sensors2, result: result2)

         net.merge()
         
         let crawler = Crawler()
         let dotString = crawler.toDot7Segment(net: net)
         
//         crawler.visualize(content: dotString)

         let netInfo = crawler.info(net: net)

         let info = netInfo.toString()
         print(info)

         
         #expect(netInfo.nodes == 7)
         #expect(netInfo.incoming == 6)
         #expect(netInfo.outgoing == 6)
         #expect(netInfo.depth == 2)
         #expect(netInfo.results == 3)
         #expect(netInfo.roots == 1)

     }

    
    
    @Test func mergeTests() async {
        
        let sevenSegments = SevenSegments()
        let net = Net()
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        
        net.merge()
        
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        
        do {
            try await crawler.visualize(content: dotString)
        } catch {
            print("error calling crawler.visualize")
        }
    }
    
    @Test func mergeComplex() async {
        
        let net = Net()
        let sensor1: Sensor = Sensor(position: 1)
        let sensor2: Sensor = Sensor(position: 2)
        let sensor3: Sensor = Sensor(position: 3)
        let sensor4: Sensor = Sensor(position: 4)
        let sensor5: Sensor = Sensor(position: 5)
        let sensor6: Sensor = Sensor(position: 6)
        let sensor7: Sensor = Sensor(position: 7)
        let sensor8: Sensor = Sensor(position: 8)
        let sensorResult1: Sensor = Sensor(position: 1)
        let sensorResult2: Sensor = Sensor(position: 2)
        let sensorResult3: Sensor = Sensor(position: 3)
        
        let node1 = Node(sensors: [sensor1, sensor2, sensor3, sensor4])
        let node2 = Node(sensors: [sensor3, sensor4, sensor5, sensor6])
        let node3 = Node(sensors: [sensor5, sensor6, sensor7, sensor8])
        var result1 = Node(sensors: [sensorResult1])
        result1.isRoot = false
        var result2 = Node(sensors: [sensorResult2])
        result2.isRoot = false
        var result3 = Node(sensors: [sensorResult3])
        result3.isRoot = false
        
        net.nodeDict[node1.id] = node1
        net.nodeDict[node2.id] = node2
        net.nodeDict[node3.id] = node3
        net.nodeDict[result1.id] = result1
        net.nodeDict[result2.id] = result2
        net.nodeDict[result3.id] = result3
        net.connector.connect(from: node1.id, to: result1.id)
        net.connector.connect(from: node2.id, to: result2.id)
        net.connector.connect(from: node3.id, to: result3.id)
        
        let crawler = Crawler()
        var netInfo = crawler.info(net: net)
        var dotString = crawler.toDot7Segment(net: net)
//        crawler.visualize(content: dotString)

        #expect(netInfo.nodes == 6)
        #expect(netInfo.incoming == 3)
        #expect(netInfo.outgoing == 3)
        #expect(netInfo.roots == 3)
        #expect(netInfo.results == 3)
        #expect(netInfo.depth == 1)
        
        net.merge(left: node1.id, right: node2.id)
        
        netInfo = crawler.info(net: net)
        dotString = crawler.toDot7Segment(net: net)
//        crawler.visualize(content: dotString)
        
        #expect(netInfo.nodes == 7)
        #expect(netInfo.incoming == 5)
        #expect(netInfo.outgoing == 5)
        #expect(netInfo.roots == 2)
        #expect(netInfo.results == 3)
        #expect(netInfo.depth == 2)
        
        // There are only two root nodes
        let rootNodes = net.rootNodeIDs()
        net.mergeComplex(left: rootNodes[0], right: rootNodes[1], basic: true)
        netInfo = crawler.info(net: net)
        dotString = crawler.toDot7Segment(net: net)
        
        do {
            try await crawler.visualize(content: dotString)
        } catch {
            print("error calling crawler.visualize")
        }
        
        #expect(netInfo.nodes == 7)
        #expect(netInfo.incoming == 6)
        #expect(netInfo.outgoing == 6)
        #expect(netInfo.roots == 2)
        #expect(netInfo.results == 3)
        #expect(netInfo.depth == 3)

        
    }
    
    
    @Test func mergeComplexMNIST() async {
        
        let positions = 10000
        let net = Net()
        
        print("Images: \(positions)")
        let dateL = Date()
        print("Load: \(dateL.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
        
        let labelPath = "idx1Label-test.txt"
        let labels = ImportExport().loadSavedLabels(file: labelPath)
        let imagePath = "idx3Image-test.txt"
        let images = await ImportExport().loadSavedImages(tasks: 10, file: imagePath)
        
        let dateD = Date()
        print("Decode: \(dateD.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
        
        let labelSensors = labels.asSensors()
        let imageSensors = images.asSensors()
        
        let trainingLabels: [Sensor]
        let trainingImages: [[Sensor]]
        
        trainingLabels = Array(labelSensors[0..<positions])
        trainingImages = Array(imageSensors[0..<positions])
        
        let dateT = Date()
        print("Train/Merge: \(dateT.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
        
        for index in 0..<positions {
            net.populate(sensors: trainingImages[index], result: trainingLabels[index])
        }
        
        let crawler = Crawler()
        var netInfo = crawler.info(net: net)
        
        print(netInfo.toString())
        
        for index in 0..<1000 {
//            print("IndexRoots0-false: \(index)")
            net.mergeComplexRootsLevel0(basic: false)
//            netInfo = crawler.info(net: net)
//            print(netInfo.toString())
        }
        netInfo = crawler.info(net: net)
        print(netInfo.toString())
        
        for index in 0..<200 {
//            print("IndexRoots0-true: \(index)")
            net.mergeComplexRootsLevel0(basic: true)
//            netInfo = crawler.info(net: net)
            print(netInfo.toString())
        }
        
        netInfo = crawler.info(net: net)
        print(netInfo.toString())
        
            let dateD2 = Date()
            print("Done: \(dateD2.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
            
            
        }
        
        
        // MARK: Search
        
        @Test func testSearch() async throws {
            
            let sevenSegments = SevenSegments()
            let net = Net()
            var sensorDict: [Int : [Sensor]] = [:]
            
            for ind in 0..<10 {
                let sensors = sevenSegments.sensors(for: ind)
                sensorDict[ind] = sensors
                let result = Sensor(position: ind)
                net.populate(sensors: sensors, result: result)
            }
            
            for ind in 0..<10 {
                let searchResult = net.searchDFS(sensors: sensorDict[ind]!)
                
                #expect(searchResult.result!.position == ind)
            }
            
        }
        
        
    @Test func testMergeDetailSevenSegments() async {
            
            let sevenSegments = SevenSegments()
            let net = Net()
            var sensorDict: [Int : [Sensor]] = [:]
            
            for ind in 0..<10 {
                let sensors = sevenSegments.sensors(for: ind)
                sensorDict[ind] = sensors
                let result = Sensor(position: ind)
                net.populate(sensors: sensors, result: result)
            }
            
            let sValueA = Sensor(position: 1)
            let sValueB = Sensor(position: 2)
            let sValueC = Sensor(position: 3)
            let sValueD = Sensor(position: 4)
            let sValueE = Sensor(position: 5)
            let sValueF = Sensor(position: 6)
            let sValueG = Sensor(position: 7)
            
//            net.merge()
            net.mergeComplexRootsLevel0(basic: true)
            net.mergeComplexRootsLevel0(basic: true)

            let crawler = Crawler()
            let dotString = crawler.toDot7Segment(net: net)
            
            do {
                try await crawler.visualize(content: dotString)
            } catch {
                print("error calling crawler.visualize")
            }
            
            let netInfo = crawler.info(net: net)
            
            let info = netInfo.toString()
            print(info)
            
            var searchResult = net.searchDFS(sensors: [sValueB, sValueC])
            if let aResult = searchResult.result {
                #expect(aResult.position == 1, "Expected search result 1, found \(aResult.position)")
            }
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueG, sValueE, sValueD])
            if let aResult = searchResult.result {
                #expect(aResult.position == 2, "Expected search result 2, found \(aResult.position)")
            }
            
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueG, sValueC, sValueD])
            if let aResult = searchResult.result {
                #expect(aResult.position == 3, "Expected search result 3, found \(aResult.position)")
            }
            searchResult = net.searchDFS(sensors:[sValueB, sValueC, sValueG, sValueF])
            if let aResult = searchResult.result {
                #expect(aResult.position == 4, "Expected search result 4, found \(aResult.position)")
            }
            
            searchResult = net.searchDFS(sensors:[sValueA, sValueF, sValueG, sValueC, sValueD])
            if let aResult = searchResult.result {
                #expect(aResult.position == 5, "Expected search result 5, found \(aResult.position)")
            }
            searchResult = net.searchDFS(sensors:[sValueE, sValueA, sValueF, sValueG, sValueC, sValueD])
            if let aResult = searchResult.result {
                #expect(aResult.position == 6, "Expected search result 6, found \(aResult.position)")
            }
            
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueC])
            if let aResult = searchResult.result {
                #expect(aResult.position == 7, "Expected search result 7, found \(aResult.position)")
            }
            
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueC, sValueD, sValueE, sValueF, sValueG])
            if let aResult = searchResult.result {
                #expect(aResult.position == 8, "Expected search result 8, found \(aResult.position)")
            }
            
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueF, sValueG, sValueC, sValueD])
            if let aResult = searchResult.result {
                #expect(aResult.position == 9, "Expected search result 9, found \(aResult.position)")
            }
            searchResult = net.searchDFS(sensors:[sValueA, sValueB, sValueC, sValueD, sValueE, sValueF])
            if let aResult = searchResult.result {
                #expect(aResult.position == 0, "Expected search result 0, found \(aResult.position)")
            }
            
        }
        
        
        @Test func testMnistTrainingSearchDFSAsync() async {
            
            let positions = 10000
            let net = Net()
            
            print("Images: \(positions)")
            let dateL = Date()
            print("Load: \(dateL.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
            
            let labelPath = "idx1Label-test.txt"
            let labels = ImportExport().loadSavedLabels(file: labelPath)
            let imagePath = "idx3Image-test.txt"
            let images = await ImportExport().loadSavedImages(tasks: 10, file: imagePath)
            
            let dateD = Date()
            print("Decode: \(dateD.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
            
            let labelSensors = labels.asSensors()
            let imageSensors = images.asSensors()
            
            let trainingLabels: [Sensor]
            let trainingImages: [[Sensor]]
            
            trainingLabels = Array(labelSensors[0..<positions])
            trainingImages = Array(imageSensors[0..<positions])
            let searchImages = Array(imageSensors[0..<100])
            
            let dateT = Date()
            print("Train/Merge: \(dateT.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
            
            for index in 0..<positions {
                net.populate(sensors: trainingImages[index], result: trainingLabels[index])
            }
    
            let crawler = Crawler()
            var netInfo = crawler.info(net: net)
//            print(netInfo.toString())

            for index in 0..<500 {
//                print("Basic - false: \(index)")
                net.mergeComplexRootsLevel0(basic: false)
//                            netInfo = crawler.info(net: net)
//                            print(netInfo.toString())
            }
            
            netInfo = crawler.info(net: net)
            print(netInfo.toString())
            
            for index in 0..<1 {
//                print("basic-true: \(index)")
                net.mergeComplexRootsLevel0(basic: true)
//                            netInfo = crawler.info(net: net)
//                            print(netInfo.toString())
            }
            
            netInfo = crawler.info(net: net)
            print(netInfo.toString())
          
            let dateC = Date()
            print("Check: \(dateC.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
            
            
            let searchResults = await net.searchDFSAsyncBatch(sensors: searchImages, tasks: 15)
            var index = 1
            var missingCount = 0
            for searchResult in searchResults {
                if let result = searchResult.result {
//                    print("\(index) - Result: \(result.asString())")
                    index += 1
                } else {
                    print("\(index) - Missing result")
                    index += 1
                    missingCount += 1
                }
            }
            print("Missing: \(missingCount)")
            let dateDone = Date()
            print("Done: \(dateDone.formatted(Date.FormatStyle().month(.twoDigits).day(.twoDigits).year().hour().minute().second(.twoDigits).secondFraction(.fractional(3)).timeZone(.iso8601(.short)))))")
        }

}

//
//  CrawlerTests.swift
//  ANetTests
//
//  Created by Gregor Schwake on 18.02.25.
//

import Testing

struct CrawlerTests {

    @Test func toDot7SegmentTests() async throws {
       
        let sevenSegments = SevenSegments()
        let net = Net()
        
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        print("dot: \(dotString)")
        
        do {
            try await crawler.visualize(content: dotString)
        } catch {
            
        }
    }
    
    @Test func infoNetTests() async throws {
        
        let sevenSegments = SevenSegments()
        let sensors = sevenSegments.sensors(for: 0)
        let result = Sensor(position: 0)
        var net = Net()
        net.populate(sensors: sensors, result: result)
        var netInfo = Crawler().info(net: net)
        
        #expect(netInfo.nodes == 2)
        #expect(netInfo.incoming == 1)
        #expect(netInfo.outgoing == 1)
        #expect(netInfo.roots == 1)
        #expect(netInfo.results == 1)
        #expect(netInfo.depth == 1)
        
        
        net = Net()
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
     
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        
        do {
            try await crawler.visualize(content: dotString)
        } catch {
            
        }
        netInfo = crawler.info(net: net)
        
        #expect(netInfo.nodes == 20)
        #expect(netInfo.incoming == 10)
        #expect(netInfo.outgoing == 10)
        #expect(netInfo.roots == 10)
        #expect(netInfo.results == 10)
        #expect(netInfo.depth == 1)

    }
    
    
    @Test func exportImportNetTests() async throws {
        
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
        _ = crawler.exportToFile(net: net, file: "test63.json")
        
//        let dotString = crawler.toDot7Segment(net: net)
//        crawler.visualize(content: dotString)

        let importedNet = crawler.importNet(file: "test63.json")!
        let netInfo = crawler.info(net: importedNet)

        let info = netInfo.toString()
        print(info)

        #expect(netInfo.nodes == 7)
        #expect(netInfo.incoming == 6)
        #expect(netInfo.outgoing == 6)
        #expect(netInfo.depth == 2)
        #expect(netInfo.results == 3)
        #expect(netInfo.roots == 1)
        
    }
    
    
    @Test func createVisualizeScript() async {
        
        let sevenSegments = SevenSegments()
        let net = Net()
        
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        do {
            try await crawler.visualize(content: dotString)
        } catch {
                
        }
    }
    
}

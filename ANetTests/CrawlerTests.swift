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
        
        crawler.visualize(content: dotString)
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
        netInfo = Crawler().info(net: net)
        
        #expect(netInfo.nodes == 20)
        #expect(netInfo.incoming == 10)
        #expect(netInfo.outgoing == 10)
        #expect(netInfo.roots == 10)
        #expect(netInfo.results == 10)
        #expect(netInfo.depth == 1)

    }

}

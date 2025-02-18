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

}

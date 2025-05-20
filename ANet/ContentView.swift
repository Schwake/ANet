//
//  ContentView.swift
//  ANet
//
//  Created by Gregor Schwake on 17.02.25.
//

import SwiftUI

struct ContentView: View {
    
    let sevenSegments = SevenSegments()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("7 Segment Display")
                .font(.title)
            VStack(alignment: .leading) {
                Button ("Visualize Population") {
                    visualizeNetPopulation()
                 }
                
                //                Button("Twilight - basic roots", action: sevenPopulate)
                //                Button("Twilight - inside roots", action: sevenPopulate)
                //                Button("Search", action: sevenPopulate)
                //
            }
            .padding()
        }
    }
    
//    func visualizePopulation() {
//        print("visualize population called")
//        Task {
//            let sevenSegments = SevenSegments()
//            let net = Net()
//            
//            for ind in 0..<10 {
//                let sensors = sevenSegments.sensors(for: ind)
//                let result = Sensor(position: ind)
//                net.populate(sensors: sensors, result: result)
//            }
//            print("task inside")
//            let crawler = Crawler()
//            
//            await crawler.createVisualizeScript()
//        }
//    }
    
    func visualizeNetPopulation() {
        print("visualize Net population called")
        Task {
            let crawler = Crawler()
            await crawler.visualizeNetPopulation()
        }
    }
    
    
    
}

#Preview {
    ContentView()
}

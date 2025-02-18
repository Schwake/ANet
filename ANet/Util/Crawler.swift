//
//  Crawler.swift
//  ANet
//
//  Created by Gregor Schwake on 18.02.25.
//

import Foundation

class Crawler {
    
    // Answer a dot file (string) that visualizes the net
    func toDot7Segment(net: Net) -> String {
        let net = net
        var  aString = String()
        
        // Define the type of graph
        // Add the ranking - from bottom to top
        aString += "  digraph {\n"
        aString += "    rankdir = BT;\n"
        //        aString += "    rankdir = LR;\n"
        
        // The connections
        let apo = """
   "
   """
        
        for nodeFrom in net.connector.fromDict.keys {
            for nodeTo in net.connector.fromDict[nodeFrom]! {
                var toValue = String()
                if net.connector.isResult(nodeID: nodeTo) {
                    toValue = ("\(net.nodeDict[nodeTo]!.sensorsAsString())")
                    toValue = "\(apo)\(toValue)\(apo)"
                    aString += ("\(toValue) [shape=box]\n")
                } else {
                    toValue = ("\(net.nodeDict[nodeTo]!.sensorsAs7Segment())")
                    toValue = "\(apo)\(toValue)\(apo)"
                }
                var fromValue = ("\(net.nodeDict[nodeFrom]!.sensorsAs7Segment())")
                fromValue = "\(apo)\(fromValue)\(apo)"
                aString += ("\(fromValue) -> \(toValue)\n")
            }
        }
        
        aString += "}"
        
        return aString
    }
    
    
    func visualize(content: String) {
        
        _ = self.saveToFile(content: content)
        // print("Basic Net: \(dotString)")
        
        //
        let commandSH = URL(fileURLWithPath: "/bin/sh")
        let paramSH = "/Users/greg/Library/Containers/de.greg.ANet/Data/Documents/net.sh"
        try! Process.run(commandSH, arguments: [paramSH])
    }
    
    
    func saveToFile(content: String) -> String {
        
        let dotString = content
        let file = "net.dot"
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try dotString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return url.absoluteString
    }
    
    
    private func getDocumentsDirectory() -> URL {
        
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
}

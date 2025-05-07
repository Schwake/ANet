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
                if net.isRootNode(nodeID: nodeFrom) {
                    aString += ("\(fromValue) [shape=box]\n")
                    aString += ("\(fromValue) -> \(toValue)\n")
                } else {
                    aString += ("\(fromValue) -> \(toValue)\n")
                }

                
  
            }
        }
        
        aString += "}"
        
        return aString
    }
    
    
    func visualize(content: String) {
        
        _ = self.saveToFile(content: content)
//        print("Basic Net: \(content)")
        
        //
        let commandSH = URL(fileURLWithPath: "/bin/sh")
        let paramSH = "/Users/gregwerk/nobel/ANet/net.sh"
        try! Process.run(commandSH, arguments: [paramSH])
    }
    
    
    func exportToFile(net: Net, file: String) -> String {
        
        do {
            let jsonData = try JSONEncoder().encode(net)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return saveToFile(content: jsonString!, file: file)
        } catch {
            print("Encoding failed: \(error)")
        }
        return ""
    }
    
    
    func saveToFile(content: String, file: String) -> String {
        
        let fileName = file
        let fileContent = content
        
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try fileContent.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return url.absoluteString
    }
    
    
    func saveToFile(content: String) -> String {
        
        let dotString = content
        let file = "net.dot"
        
        return saveToFile(content: dotString, file: file)
    }
    
    
    func importNet(file: String) -> Net? {
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Net.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
    
    
    private func getDocumentsDirectory() -> URL {
        
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
//        print("Paths: \(paths[0])")
        return paths[0]
    }
    
    
    func info(net: Net ) -> NetInfo {
        
        var nodes = 0
        var outgoing = 0
        var incoming = 0
        var roots = 0
        var results = 0
        var depth = 0
        var rootsInside = 0
        
        for (id, node) in net.nodeDict {
            net.connector.isResult(nodeID: id) ? results += 1 : ()
            node.isRoot ? roots += 1 : ()
        }
        
        nodes = net.nodeDict.count
        for value in net.connector.fromDict.values {
            outgoing += value.count
        }
        
        for value in net.connector.toDict.values {
            incoming += value.count
        }
 
 
        for rootID in net.rootNodeIDs() {
            
            var nodeStack = [rootID]
            var depthStack: [Int] = []

            depthStack.append(0)
            
            while !nodeStack.isEmpty {
                let currID = nodeStack.removeLast()
                let currDepth = depthStack.removeLast()
                let localDepth = currDepth
                depth = max(depth, localDepth)
                for child in net.connector.outgoing(from: currID) {
                    nodeStack.insert(child, at: 0)
                    depthStack.insert(localDepth + 1, at: 0)
                }
            }
        }
        
        roots = net.rootNodeIDs().count
        rootsInside = net.rootNodeIDsInternal().count
        
        return NetInfo(nodes: nodes, incoming: incoming, outgoing: outgoing, depth: depth, results: results, roots: roots, rootsInside: rootsInside)
        
    }
    
}

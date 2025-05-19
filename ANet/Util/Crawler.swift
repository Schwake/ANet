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
    
    
    func createVisualizeScript() async  {
        
        let sevenSegments = SevenSegments()
        let net = Net()
        
        for ind in 0..<10 {
            let sensors = sevenSegments.sensors(for: ind)
            let result = Sensor(position: ind)
            net.populate(sensors: sensors, result: result)
        }
        print("population done")
        let crawler = Crawler()
        let dotString = crawler.toDot7Segment(net: net)
        print("dot string created")
        do {
            print("start visualize")
            try await crawler.visualize(content: dotString)
//            try await crawler.visualizeMultipleCommands(content: dotString)
        } catch {
            print("error")
        }
    }
    
    
    func visualize2(content: String) {
        
        self.saveToFile(content: content)
//        print("Basic Net: \(content)")
        
        //
        let commandSH = URL(fileURLWithPath: "/bin/sh")
        let paramSH = "/Users/gregwerk/nobel/ANet/net.sh"
        try! Process.run(commandSH, arguments: [paramSH])
    }
    

    func visualize(content: String) async throws {
        
        saveToFile(content: content, file: "net.dot")
        
        // Get the current working directory
        guard let currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not get the current directory.")
            return
        }
        print("Current directory \(currentDirectory)")
        
        // Create the full path for the dot command, script, dot and pdf files
        let scriptUrl = currentDirectory.appendingPathComponent("net.sh")
        print("scriptUrl \(scriptUrl)")
        
        // dot - graphviz expected to be installed and dot to be in path
     let dotCmd = "/opt/homebrew/Cellar/graphviz/12.2.1/bin/dot"
//        let dotCmd = "dot"
//        let dotCmd = currentDirectory.appendingPathComponent("dot").path()
        print("dotCmd \(dotCmd)")
        
        let dotUrl = currentDirectory.appendingPathComponent("net.dot").path()
        print("dotUrl \(dotUrl)")
        
        let pdfUrl = currentDirectory.appendingPathComponent("net.pdf").path()
        print("pdfUrl \(pdfUrl)")
        
        var scriptContent = "#!/bin/bash \n"
        scriptContent += "\(dotCmd) -Tpdf \(dotUrl) -o \(pdfUrl) \n"
        scriptContent += "open \(pdfUrl) \n"
        
        saveToFile(content: scriptContent, file: "net.sh")
        
        let commandSH = URL(fileURLWithPath: "/bin/sh")
        print("commandSH \(commandSH)")
        
        let paramSH = scriptUrl.path
        print("paramSH \(paramSH)")
        try! Process.run(commandSH, arguments: [paramSH])
    }
   
    
    
    func visualizeMultipleCommands(content: String) async throws {
        print("visualize multiple")
        saveToFile(content: content, file: "net.dot")
        
        // Get the current working directory
        guard let currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not get the current directory.")
            return
        }
        print("Current directory \(currentDirectory)")
        
        // dot - graphviz expected to be installed and dot to be in path
        let dotCmd = "/opt/homebrew/Cellar/graphviz/12.2.1/bin/dot"
         print("dotCmd \(dotCmd)")
        
        let dotUrl = currentDirectory.appendingPathComponent("net.dot").path()
        print("dotUrl \(dotUrl)")
        
        let pdfUrl = currentDirectory.appendingPathComponent("net.pdf").path()
        print("pdfUrl \(pdfUrl)")
        
        // Create the pdf file
        var commandSH = URL(fileURLWithPath: dotCmd)
        print("commandSH \(commandSH)")
        var paramSH = "dotUrl -Tpdf \(dotUrl) -o \(pdfUrl)"
        print("paramSH \(paramSH)")
        try! Process.run(commandSH, arguments: [paramSH])
        
        // Open the pdf file
        commandSH = URL(fileURLWithPath: "open")
        print("commandSH \(commandSH)")
        paramSH = pdfUrl
        print("paramSH \(paramSH)")
        try! Process.run(commandSH, arguments: [paramSH])

        
        
    }
    
    func cmdExecution(command: URL, param: [String]) {
        try! Process.run(command, arguments: param)
    }
    
    
    func exportToFile(net: Net, file: String) {
        
        do {
            let jsonData = try JSONEncoder().encode(net)
            let jsonString = String(data: jsonData, encoding: .utf8)
            saveToFile(content: jsonString!, file: file)
        } catch {
            print("Encoding failed: \(error)")
        }
        return
    }
    
    
    func saveToFile(content: String, file: String) {
        
        let fileName = file
        let fileContent = content
        
        // Get the current working directory
        guard let currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not get the current directory.")
            return
        }
        
        // Create the full path for the file
        let fileURL = currentDirectory.appendingPathComponent(fileName)

        do {
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Successfully wrote to file: \(fileURL)")
        } catch {
            print(error.localizedDescription)
            print("Failed to write to file: \(error)")
        }
       
    }
    
    
    func writeToFile() {
        let fileName = "example.txt"
        let fileContent = "Hello, World!"
        
        // Get the current working directory
        guard let currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not get the current directory.")
            return
        }
        
        // Create the full path for the file
        let fileURL = currentDirectory.appendingPathComponent(fileName)
        
        // Write the content to the file
        do {
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Successfully wrote to file: \(fileURL)")
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
    
    
    func saveToFile(content: String) {
        
        let dotString = content
        let file = "net.dot"
        
        saveToFile(content: dotString, file: file)
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

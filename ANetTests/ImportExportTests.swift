//
//  ImportExportTests.swift
//  InfoNetTests
//
//  Created by Gregor Schwake on 09/06/2022.
//

import Testing
import Foundation

struct ImportExportTests {
    
    @Test func testLoadLabelsTest() {
        
        let aPath = "/Users/greg/Documents/mnist/t10k-labels-idx1-ubyte"
        
        let anIdx1Label = ImportExport().loadLabels(path: aPath)
        
        #expect(anIdx1Label.magicNumber == 2049)
        #expect(anIdx1Label.numberOfRecords == 10000)
        #expect(anIdx1Label.labels.count == 10000)
        #expect(anIdx1Label.labels[0] == 7)
        #expect(anIdx1Label.labels[1] == 2)
        #expect(anIdx1Label.labels[2] == 1)
        #expect(anIdx1Label.labels[3] == 0)
        #expect(anIdx1Label.labels[4] == 4)
        #expect(anIdx1Label.labels[5] == 1)
        #expect(anIdx1Label.labels[6] == 4)
        #expect(anIdx1Label.labels[7] == 9)
        #expect(anIdx1Label.labels[9997] == 4)
        #expect(anIdx1Label.labels[9998] == 5)
        #expect(anIdx1Label.labels[9999] == 6)
    }
    
    
    @Test func testLoadLabelsTraining() {
        
        let aPath = ("/Users/greg/Documents/mnist/train-labels-idx1-ubyte" as NSString).expandingTildeInPath
        let anIdx1Label = ImportExport().loadLabels(path: aPath)
        
        #expect(anIdx1Label.magicNumber == 2049)
        #expect(anIdx1Label.numberOfRecords == 60000)
        #expect(anIdx1Label.labels.count == 60000)
        #expect(anIdx1Label.labels[0] == 5)
        #expect(anIdx1Label.labels[1] == 0)
        #expect(anIdx1Label.labels[2] == 4)
        #expect(anIdx1Label.labels[3] == 1)
        #expect(anIdx1Label.labels[4] == 9)
        #expect(anIdx1Label.labels[5] == 2)
        #expect(anIdx1Label.labels[6] == 1)
        #expect(anIdx1Label.labels[7] == 3)
        #expect(anIdx1Label.labels[59997] == 5)
        #expect(anIdx1Label.labels[59998] == 6)
        #expect(anIdx1Label.labels[59999] == 8)
    }
    
    
    @Test func testLoadImagesTest() {
        
        let aPath = ("/Users/greg/Documents/mnist/t10k-images-idx3-ubyte" as NSString).expandingTildeInPath
        let anIdx3Image = ImportExport().loadImages(path: aPath)
        
        #expect(anIdx3Image.magicNumber == 2051, "Expected 2051 got \(anIdx3Image.magicNumber)")
        #expect(anIdx3Image.numberOfRecords == 10000, "Expected 10.000 got \(anIdx3Image.numberOfRecords)")
        #expect(anIdx3Image.images.count == 10000, "Expected 10.000 got \(anIdx3Image.images.count)")
        #expect(anIdx3Image.numberOfRows == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.numberOfColumns == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.images[0].count == 28, "Expected 28 rows got \(anIdx3Image.images[0].count)")
        #expect(anIdx3Image.images[0][0].count == 28, "Expected 28 columns got \(anIdx3Image.images[0][0].count)")
        #expect(anIdx3Image.images[0][0][0] == 0)
        #expect(anIdx3Image.images[0][1][0] == 0)
        #expect(anIdx3Image.images[0][2][0] == 0)
        #expect(anIdx3Image.images[0][3][0] == 0)
        #expect(anIdx3Image.images[0][4][0] == 0)
        #expect(anIdx3Image.images[9999][21][18] == 1, "Expected 1 got \(anIdx3Image.images[9999][21][18])")
        #expect(anIdx3Image.images[9999][21][19] == 1, "Expected 1 got \(anIdx3Image.images[9999][21][19])")
        #expect(anIdx3Image.images[9999][27][24] == 0)
        #expect(anIdx3Image.images[9999][27][25] == 0)
        #expect(anIdx3Image.images[9999][27][26] == 0)
        
    }
    
    
    @Test func testLoadImagesTraining() {
        
        let aPath = ("/Users/greg/Documents/mnist/train-images-idx3-ubyte" as NSString).expandingTildeInPath
        let anIdx3Image = ImportExport().loadImages(path: aPath)
        
        #expect(anIdx3Image.magicNumber == 2051, "Expected 2051 got \(anIdx3Image.magicNumber)")
        #expect(anIdx3Image.numberOfRecords == 60000, "Expected 60.000 got \(anIdx3Image.numberOfRecords)")
        #expect(anIdx3Image.images.count == 60000, "Expected 60.000 got \(anIdx3Image.images.count)")
        #expect(anIdx3Image.numberOfRows == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.numberOfColumns == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.images[0].count == 28, "Expected 28 rows got \(anIdx3Image.images[0].count)")
        #expect(anIdx3Image.images[0][0].count == 28, "Expected 28 columns got \(anIdx3Image.images[0][0].count)")
        #expect(anIdx3Image.images[0][0][0] == 0)
        #expect(anIdx3Image.images[0][1][0] == 0)
        #expect(anIdx3Image.images[0][2][0] == 0)
        #expect(anIdx3Image.images[0][3][0] == 0)
        #expect(anIdx3Image.images[0][4][0] == 0)
        #expect(anIdx3Image.images[59999][23][8] == 1, "Expected 1 got \(anIdx3Image.images[59999][23][8])")
        #expect(anIdx3Image.images[59999][23][9] == 1, "Expected 1 got \(anIdx3Image.images[59999][23][9])")
        #expect(anIdx3Image.images[59999][23][10] == 1, "Expected 1 got \(anIdx3Image.images[59999][23][10])")
        #expect(anIdx3Image.images[59999][23][11] == 1, "Expected 1 got \(anIdx3Image.images[59999][23][11])")
        #expect(anIdx3Image.images[59999][27][24] == 0)
        #expect(anIdx3Image.images[59999][27][25] == 0)
        #expect(anIdx3Image.images[59999][27][26] == 0)
    }
    
    
    // Load test and training data and save it to Documents/mnist
    @Test func testSaveToInternal() async {
        
        await ImportExport().saveToInternal()
    }
    
    
    @Test func testLoadSavedImages() async {
        
        let file = "idx3Image-test.txt"
        let anIdx3Image = await ImportExport().loadSavedImages(tasks: 10, file: file)
        
        #expect(anIdx3Image.magicNumber == 2051, "Expected 2051 got \(anIdx3Image.magicNumber)")
        #expect(anIdx3Image.numberOfRecords == 10000, "Expected 10.000 got \(anIdx3Image.numberOfRecords)")
        #expect(anIdx3Image.images.count == 10000, "Expected 10.000 got \(anIdx3Image.images.count)")
        #expect(anIdx3Image.numberOfRows == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.numberOfColumns == 28, "Expected 28 got \(anIdx3Image.numberOfRows)")
        #expect(anIdx3Image.images[0].count == 28, "Expected 28 rows got \(anIdx3Image.images[0].count)")
        #expect(anIdx3Image.images[0][0].count == 28, "Expected 28 columns got \(anIdx3Image.images[0][0].count)")
        #expect(anIdx3Image.images[0][0][0] == 0)
        #expect(anIdx3Image.images[0][1][0] == 0)
        #expect(anIdx3Image.images[0][2][0] == 0)
        #expect(anIdx3Image.images[0][3][0] == 0)
        #expect(anIdx3Image.images[0][4][0] == 0)
        #expect(anIdx3Image.images[9999][21][18] == 1, "Expected 1 got \(anIdx3Image.images[9999][21][18])")
        #expect(anIdx3Image.images[9999][21][19] == 1, "Expected 1 got \(anIdx3Image.images[9999][21][19])")
        #expect(anIdx3Image.images[9999][27][24] == 0)
        #expect(anIdx3Image.images[9999][27][25] == 0)
        #expect(anIdx3Image.images[9999][27][26] == 0)
    }
    
    
    @Test func testLoadSavedLabels() {
        
        let file = "idx1Label-test.txt"
        let anIdx1Label = ImportExport().loadSavedLabels(file: file)
        
        
        #expect(anIdx1Label.magicNumber == 2049)
        #expect(anIdx1Label.numberOfRecords == 10000)
        #expect(anIdx1Label.labels.count == 10000)
        #expect(anIdx1Label.labels[0] == 7)
        #expect(anIdx1Label.labels[1] == 2)
        #expect(anIdx1Label.labels[2] == 1)
        #expect(anIdx1Label.labels[3] == 0)
        #expect(anIdx1Label.labels[4] == 4)
        #expect(anIdx1Label.labels[5] == 1)
        #expect(anIdx1Label.labels[6] == 4)
        #expect(anIdx1Label.labels[7] == 9)
        #expect(anIdx1Label.labels[9997] == 4)
        #expect(anIdx1Label.labels[9998] == 5)
        #expect(anIdx1Label.labels[9999] == 6)
    }
    
}

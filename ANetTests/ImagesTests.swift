//
//  ImagesTests.swift
//  InfoNetTests
//
//  Created by Gregor Schwake on 09/06/2022.
//


import Testing

struct ImagesTest {

    @Test func testSplit() async {

        let file = "idx3Image-test.txt"
        let anIdx3Image = await ImportExport().loadSavedImages(tasks: 10, file: file)

        let idx3Images = anIdx3Image.split(parts: 3)

        // There are 10.000 test images
        // There should be 4 Idx3Image
        #expect(idx3Images.count == 4)

        // The first three Idx3Image should have 3.333 records each
        #expect(idx3Images[0].images.count == 3333)
        #expect(idx3Images[0].numberOfRecords == 3333)
        #expect(idx3Images[0].magicNumber == anIdx3Image.magicNumber)
        #expect(idx3Images[1].images.count == 3333)
        #expect(idx3Images[1].numberOfRecords == 3333)
        #expect(idx3Images[1].magicNumber == anIdx3Image.magicNumber)
        #expect(idx3Images[2].images.count == 3333)
        #expect(idx3Images[2].numberOfRecords == 3333)
        #expect(idx3Images[2].magicNumber == anIdx3Image.magicNumber)

        // The last Idx1Label should have 1 record
        #expect(idx3Images[3].images.count == 1)
        #expect(idx3Images[3].numberOfRecords == 1)
        #expect(idx3Images[3].magicNumber == anIdx3Image.magicNumber)

    }


    @Test func testLimitImagePixel() async {

        let fileImages = "idx3Image-test.txt"
        let idx3Images = await ImportExport().loadSavedImages(tasks: 10, file: fileImages)

        var idx3ImagesLimited = idx3Images
        idx3ImagesLimited.limitImagePixel()

        for imageInd in 0...(idx3Images.images.count - 1) {
            for rowInd in 0...27 {
                for colInd in 0...27 {
                    #expect(((idx3Images.images[imageInd][rowInd][colInd] > 0) && (idx3ImagesLimited.images[imageInd][rowInd][colInd] == 1)) ||
                        (idx3Images.images[imageInd][rowInd][colInd] == 0) && (idx3ImagesLimited.images[imageInd][rowInd][colInd] == 0))
                }
            }
        }


    }


}

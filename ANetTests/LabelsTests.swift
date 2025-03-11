//
//  LabelsTests.swift
//  InfoNetTests
//
//  Created by Gregor Schwake on 09/06/2022.
//

import Testing

struct LabelsTests {

    @Test func testSplit() async {

        let file = "idx1Label-test.txt"
        let anIdx1Label = ImportExport().loadSavedLabels(file: file)

        let idx1Labels = anIdx1Label.split(parts: 3)

        // There are 10.000 test labels
        // There should be 4 Idx1Label
        #expect(idx1Labels.count == 4)

        // The first three Idx1Label should have 3.333 records each
        #expect(idx1Labels[0].labels.count == 3333)
        #expect(idx1Labels[0].numberOfRecords == 3333)
        #expect(idx1Labels[0].magicNumber == anIdx1Label.magicNumber)
        #expect(idx1Labels[1].labels.count == 3333)
        #expect(idx1Labels[1].numberOfRecords == 3333)
        #expect(idx1Labels[1].magicNumber == anIdx1Label.magicNumber)
        #expect(idx1Labels[2].labels.count == 3333)
        #expect(idx1Labels[2].numberOfRecords == 3333)
        #expect(idx1Labels[2].magicNumber == anIdx1Label.magicNumber)

        // The last Idx1Label should have 1 record
        #expect(idx1Labels[3].labels.count == 1)
        #expect(idx1Labels[3].numberOfRecords == 1)
        #expect(idx1Labels[3].magicNumber == anIdx1Label.magicNumber)

    }

}


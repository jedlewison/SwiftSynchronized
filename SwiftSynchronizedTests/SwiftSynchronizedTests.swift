//
//  SwiftSynchronizedTests.swift
//  SwiftSynchronizedTests
//
//  Created by Jed Lewison on 8/30/15.
//  Copyright © 2015 Magic App Factory. All rights reserved.
//

import XCTest
import SwiftSynchronized

class SwiftSynchronizedTests: XCTestCase {

    var counter = 0
    let blockOpCount = 10000
    let delay: useconds_t = 1
    override func setUp() {
        super.setUp()
        counter = 0
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Allow block operations to simultaneously mutate a property without synchronizing access.
    // The block operation will increment a counter and attempt to decrement it but only if
    // it hasn't been incremented by another operation (when the counter isn't one)

    func incrementCounter() {
        counter++
    }

    func decrementCounterIfPossible() {
        if counter == 1 {
            counter--
        } else {
            // Another operation has incremented the counter before we got a chance to decrement it
        }
    }

    func performOperation() {
        incrementCounter()
        usleep(delay)
        decrementCounterIfPossible()
    }


    func testWithoutSwiftSynchronized() {

        var blockOps = [NSBlockOperation]()

        for _ in 0...blockOpCount {
            let blockOperation = NSBlockOperation() {
                self.performOperation()
            }
            blockOps.append(blockOperation)
        }

        let operationQ = NSOperationQueue()

        operationQ.addOperations(blockOps, waitUntilFinished: true)
        print(counter)
        XCTAssert(counter > 0, "Max count is \(counter)")
    }

    // Add synchronized directive to protect block of code.
    // Synchronized should give the operation a chance to decrement
    // the count before another operation increments it.

    func testWithSwiftSynchronizedExample() {

        var blockOps = [NSBlockOperation]()

        for _ in 0...blockOpCount {
            let blockOperation = NSBlockOperation() {
                synchronized(self) {
                    self.performOperation()
                }
            }
            blockOps.append(blockOperation)
        }

        let operationQ = NSOperationQueue()

        operationQ.addOperations(blockOps, waitUntilFinished: true)

        print(counter)

        XCTAssert(counter == 0, "Max count is \(counter)")
    }

    func testtestWithSwiftSynchronizedReturnExample() {

        var blockOps = [NSBlockOperation]()

        var localcounter = 0

        for _ in 0...blockOpCount {
            let blockOperation = NSBlockOperation() {
                localcounter = synchronized(self) {
                    self.performOperation()
                    return self.counter
                }
            }
            blockOps.append(blockOperation)
        }

        let operationQ = NSOperationQueue()

        operationQ.addOperations(blockOps, waitUntilFinished: true)

        print(localcounter)

        XCTAssert(localcounter == 0, "Local max count is \(localcounter)")
    }

    func testWithSwiftSynchronizedExampleWithMultipleSynchObjects() {

        var blockOps = [NSBlockOperation]()

        for _ in 0...blockOpCount {
            let blockOperation = NSBlockOperation() {
                synchronized(NSObject()) {
                    self.performOperation()
                }
            }
            blockOps.append(blockOperation)
        }

        let operationQ = NSOperationQueue()

        operationQ.addOperations(blockOps, waitUntilFinished: true)

        print(counter)

        XCTAssert(counter != 0, "Max count is \(counter)")
    }
    
}

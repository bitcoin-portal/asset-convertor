//
//  File.swift
//
//
//  Created by Nhat Dinh on 2024/04/22.
//

import Foundation
import XCTest

@testable import AssetConverters

final class ThreadSafeCacheTests: XCTestCase {
    func testCanStoreAndRetrieveValueConcurrently() {
        let cache = ThreadSafeCache<String, Int>()
        DispatchQueue.concurrentPerform(iterations: 100000) { iteration in
            let key = "Key\(iteration)"
            cache.setValue(iteration, forKey: key)
            if let value = cache.getValue(forKey: key) {
                print("Thread \(iteration) retrieved value: \(value)")
            } else {
                XCTFail()
            }
        }
    }
}

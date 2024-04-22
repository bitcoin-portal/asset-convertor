//
//  AssetConverterInteractorTests.swift
//
//
//  Created by Nhat Dinh on 2024/04/22.
//

import Foundation
import XCTest

@testable import AssetConverters

final class AssetConverterInteractorTests: XCTestCase {
    func testMultipleThreadExecution() {
        let sut = AssetConverterInteractor()
        DispatchQueue.concurrentPerform(iterations: 100000) { iteration in
            XCTAssertEqual(sut.convertProviderAssetToAssetIdV2(asset: "VERSE-ETH", provider: .banxa), "ETH-ERC20-0x249cA82617eC3DfB2589c4c17ab7EC9765350a18")
            XCTAssertEqual(sut.convertProviderAssetToAssetIdV2(asset: "VERSE-ETH", provider: .moonpay), nil)
            XCTAssertEqual(sut.convertProviderAssetToAssetIdV2(asset: "VERSE", provider: .moonpay), "ETH-ERC20-0x249cA82617eC3DfB2589c4c17ab7EC9765350a18")
            XCTAssertEqual(sut.convertProviderAssetToAssetIdV2(asset: "VERSE-ETH", provider: .simplex), nil)

            XCTAssertEqual(sut.convertAssetIdV2ToProviderAsset(assetIdV2: "ETH-ERC20-0x249cA82617eC3DfB2589c4c17ab7EC9765350a18", provider: .banxa), "VERSE-ETH")
            XCTAssertEqual(sut.convertAssetIdV2ToProviderAsset(assetIdV2: "ETH-ERC20-0x249cA82617eC3DfB2589c4c17ab7EC9765350a18", provider: .moonpay), "VERSE")
            XCTAssertEqual(sut.convertAssetIdV2ToProviderAsset(assetIdV2: "ETH-ERC20-0x249cA82617eC3DfB2589c4c17ab7EC9765350a18", provider: .simplex), nil)
        }
    }
}

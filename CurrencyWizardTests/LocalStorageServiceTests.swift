//
//  LocalStorageServiceTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class LocalStorageServiceTests: XCTestCase {
	func test_initSUT_shouldNotRequestAnything() {
		let sut = makeSUT()
		XCTAssertEqual(sut.internalCalls, [])
	}
	
	// MARK: Helpers
	private func makeSUT() -> LocalStorageServiceStub {
		return LocalStorageServiceStub()
	}
}

private class LocalStorageServiceStub: LocalStorageService {

	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}


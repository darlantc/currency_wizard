//
//  CurrencyServiceTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 16/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

struct CurrencyOption {
	let name: String
	let id: String
}

protocol CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void)
}

class CurrencyServiceTests: XCTestCase {
	func test_initSUT_shouldNotRequestAnything() {
		let sut = makeSUT()
		XCTAssertEqual(sut.internalCalls, [])
	}
	
	func test_requestCurrencyOptions_shouldRequestCurrencyOptions() {
		var requestCount = 0
		
		func requestCallback(options: [CurrencyOption]) -> Void {
			requestCount += 1
		}
		
		let sut = makeSUT()
		sut.requestCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(sut.internalCalls, ["requestCurrencyOptions"])
		
		sut.requestCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(sut.internalCalls, ["requestCurrencyOptions", "requestCurrencyOptions"])
	}
	
	func test_requestCurrencyOptions_shouldReturnValidData() {
		var response = [CurrencyOption]()
		
		let sut = makeSUT()
		sut.requestCurrencyOptions { response = $0 }

		XCTAssertFalse(response.isEmpty)
	}
	
	
	// MARK: Helpers
	private func makeSUT() -> CurrencyServiceStub {
		return CurrencyServiceStub()
	}
}

private class CurrencyServiceStub: CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void) {
		self.didCall(function: "requestCurrencyOptions")
		completion([
			CurrencyOption(name: "United States Dollar", id: "USD")
		])
	}
	
	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}

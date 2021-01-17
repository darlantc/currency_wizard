//
//  CurrencyServiceTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 16/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

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
	
	func test_requestExchangeRate_shouldRequestExchangeRate() {
		var requestCount = 0
		
		func requestCallback(exchangeRate: Double) -> Void {
			requestCount += 1
		}
		
		let sut = makeSUT()
		sut.requestExchangeRate(from: usdCurrencyOption, to: eurCurrencyOption, completion: requestCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(sut.internalCalls, ["requestExchangeRate"])
		
		sut.requestExchangeRate(from: eurCurrencyOption, to: usdCurrencyOption, completion: requestCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(sut.internalCalls, ["requestExchangeRate", "requestExchangeRate"])
	}
	
	func test_requestExchangeRate_shouldReturnValidDouble() {
		var response: Double = 0
		
		let sut = makeSUT()
		sut.requestExchangeRate(from: usdCurrencyOption, to: eurCurrencyOption) { response = $0 }
		XCTAssertTrue(response > 0)
	}
	
	// MARK: Helpers
	private func makeSUT() -> CurrencyServiceStub {
		return CurrencyServiceStub()
	}
}

private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

private class CurrencyServiceStub: CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void) {
		self.didCall(function: "requestCurrencyOptions")
		completion([
			usdCurrencyOption,
			eurCurrencyOption
		])
	}
	
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: (Double) -> Void) {
		self.didCall(function: "requestExchangeRate")
		completion(1.0)
	}
	
	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}

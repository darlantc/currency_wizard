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
	
	func test_requestLastUsedCurrencyOptions_shouldCallMethod() {
		var requestCount = 0
		
		func requestCallback(lastUsedOptions: (from: CurrencyOption, to: CurrencyOption)?) -> Void {
			requestCount += 1
		}
		
		let sut = makeSUT()
		sut.requestLastUsedCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(sut.internalCalls, ["requestLastUsedCurrencyOptions"])
		
		sut.requestLastUsedCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(sut.internalCalls, ["requestLastUsedCurrencyOptions", "requestLastUsedCurrencyOptions"])
	}
	
	func test_requestLastUsedCurrencyOptions_shouldReturnValidData() {
		var response: (from: CurrencyOption, to: CurrencyOption)? = nil
		
		let sut = makeSUT()
		sut.requestLastUsedCurrencyOptions { response = $0 }
		
		XCTAssertEqual(response?.from.id, "USD")
		XCTAssertEqual(response?.to.id, "EUR")
	}
	
	// MARK: Helpers
	private func makeSUT() -> LocalStorageServiceStub {
		return LocalStorageServiceStub()
	}
}

private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

private class LocalStorageServiceStub: LocalStorageService {
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		completion((usdCurrencyOption, eurCurrencyOption))
		self.didCall(function: "requestLastUsedCurrencyOptions")
	}

	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}


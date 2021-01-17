//
//  LastUsedCurrencyOptionsUseCaseTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class LastUsedCurrencyOptionsUseCaseTests: XCTestCase {
	func test_initSUT_shouldBeNil() {
		let sut = makeSUT()
		
		XCTAssertNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNil(sut.lastUsedToCurrencyOption)
	}
	
	func test_initWithLastUsedFrom_shouldBeNil() {
		let sut = makeSUT(lastUsedFromCurrencyOption: usdCurrencyOption)
		
		XCTAssertNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNil(sut.lastUsedToCurrencyOption)
	}
	
	func test_initWithLastUsedTo_shouldBeNil() {
		let sut = makeSUT(lastUsedToCurrencyOption: eurCurrencyOption)
		
		XCTAssertNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNil(sut.lastUsedToCurrencyOption)
	}
	
	func test_initWithBothLastUsedFromAndTo_shouldReturnIt() {
		let sut = makeSUT(
			lastUsedFromCurrencyOption: usdCurrencyOption,
			lastUsedToCurrencyOption: eurCurrencyOption)
		
		XCTAssertNotNil(sut.lastUsedFromCurrencyOption)
		XCTAssertEqual(sut.lastUsedFromCurrencyOption, usdCurrencyOption)
		XCTAssertNotNil(sut.lastUsedToCurrencyOption)
		XCTAssertEqual(sut.lastUsedToCurrencyOption, eurCurrencyOption)
	}
	
	func test_initWithoutLastUsed_saveLastUsed_shouldReturnIt() {
		var localStorageServiceDidCallListener = [String]()
		let sut = makeSUT() { localStorageServiceDidCallListener.append($0) }
		
		sut.saveLastUsedCurrencyOptions(from: eurCurrencyOption, to: usdCurrencyOption)
		XCTAssertEqual(sut.lastUsedFromCurrencyOption, eurCurrencyOption)
		XCTAssertEqual(sut.lastUsedToCurrencyOption, usdCurrencyOption)
		XCTAssertEqual(localStorageServiceDidCallListener, ["requestLastUsedCurrencyOptions", "saveLastUsedCurrencyOptions"])
		
		sut.saveLastUsedCurrencyOptions(from: usdCurrencyOption, to: eurCurrencyOption)
		XCTAssertEqual(sut.lastUsedFromCurrencyOption, usdCurrencyOption)
		XCTAssertEqual(sut.lastUsedToCurrencyOption, eurCurrencyOption)
		XCTAssertEqual(localStorageServiceDidCallListener, ["requestLastUsedCurrencyOptions", "saveLastUsedCurrencyOptions", "saveLastUsedCurrencyOptions"])
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil,
		localStorageServiceDidCallListener: ((String) -> Void)? = nil
	) -> LastUsedCurrencyOptionsUseCase {
		let localStorageService = LocalStorageServiceMock(
			didCallListener: localStorageServiceDidCallListener,
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
		return LastUsedCurrencyOptionsUseCase(localStorageService: localStorageService)
	}
}

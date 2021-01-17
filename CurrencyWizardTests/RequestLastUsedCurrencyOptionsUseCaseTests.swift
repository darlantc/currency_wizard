//
//  RequestLastUsedCurrencyOptionsUseCaseTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class RequestLastUsedCurrencyOptionsUseCaseTests: XCTestCase {
	func test_initSUT_shouldBeNil() {
		let sut = makeSUT()
		
		XCTAssertNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNil(sut.lastUsedToCurrencyOption)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil,
		localStorageServiceDidCallListener: ((String) -> Void)? = nil
	) -> RequestLastUsedCurrencyOptionsUseCase {
		let localStorageService = LocalStorageServiceMock(
			didCallListener: localStorageServiceDidCallListener,
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
		return RequestLastUsedCurrencyOptionsUseCase(localStorageService: localStorageService)
	}
}

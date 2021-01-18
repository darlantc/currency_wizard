//
//  SelectCurrencyOptionViewModelTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class SelectCurrencyOptionViewModelTests: XCTestCase {
	func test_initSUT_shouldHaveEmptyList() {
		let sut = makeSUT()
		XCTAssertTrue(sut.currencyOptionsList.isEmpty)
	}
	
	func test_requestCurrencyOptions_noneAvailableFromCurrencyService_shouldHaveEmptyList() {
		let sut = makeSUT(options: [])
		sut.requestCurrencyOptions()
		XCTAssertTrue(sut.currencyOptionsList.isEmpty)
	}
	
	func test_requestCurrencyOptions_twoAvailableFromCurrencyService_shouldReturnBoth() {
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		sut.requestCurrencyOptions()
		XCTAssertEqual(sut.currencyOptionsList.count, 2)
		XCTAssertEqual(sut.currencyOptionsList.first!, usdCurrencyOption)
		XCTAssertEqual(sut.currencyOptionsList.last!, eurCurrencyOption)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(options: [CurrencyOption] = []) -> SelectCurrencyOptionViewModel {
		let currencyService = CurrencyServiceMock(options: options)
		let requestCurrencyOptionsUseCase = RequestCurrencyOptionsUseCase(currencyService: currencyService)
		return SelectCurrencyOptionViewModel(requestCurrencyOptionsUseCase: requestCurrencyOptionsUseCase)
	}
}

//
//  ConvertCurrenciesViewModelTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import XCTest
@testable import CurrencyWizard

class ConvertCurrenciesViewModelTests: XCTestCase {
	func test_initSUT_withoutLastUsed_shouldBeNil() {
		let sut = makeSUT()
		XCTAssertNil(sut.fromCurrencyOption.value)
		XCTAssertNil(sut.toCurrencyOption.value)
	}
	
	func test_initSUT_withLastUsed_shouldNotBeNil() {
		let sut = makeSUT(
			lastUsedFromCurrencyOption: usdCurrencyOption,
			lastUsedToCurrencyOption: eurCurrencyOption
		)
		XCTAssertEqual(sut.fromCurrencyOption.value, usdCurrencyOption)
		XCTAssertEqual(sut.toCurrencyOption.value, eurCurrencyOption)
	}
	
	func test_initSUT_withLastUsed_swapCurrencyOptions_shouldSwapThem() {
		let sut = makeSUT(
			lastUsedFromCurrencyOption: usdCurrencyOption,
			lastUsedToCurrencyOption: eurCurrencyOption
		)
		sut.swapCurrencyOptions()
		XCTAssertEqual(sut.fromCurrencyOption.value, eurCurrencyOption)
		XCTAssertEqual(sut.toCurrencyOption.value, usdCurrencyOption)
		
		sut.swapCurrencyOptions()
		XCTAssertEqual(sut.fromCurrencyOption.value, usdCurrencyOption)
		XCTAssertEqual(sut.toCurrencyOption.value, eurCurrencyOption)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(
		exchangeRateValue: Double = 0,
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) -> ConvertCurrenciesViewModel {
		let convertCurrencyUseCase = makeConvertCurrencyUseCase(exchangeRateValue: exchangeRateValue)
		let lastUsedCurrencyOptionsUseCase = makeLastUsedCurrencyOptionsUseCase(
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
		return ConvertCurrenciesViewModel(
			convertCurrencyUseCase: convertCurrencyUseCase,
			lastUsedCurrencyOptionsUseCase: lastUsedCurrencyOptionsUseCase
		)
	}
	
	func makeConvertCurrencyUseCase(exchangeRateValue: Double = 0) -> ConvertCurrencyUseCase {
		let currencyService = CurrencyServiceMock(exchangeRateValue: exchangeRateValue)
		return ConvertCurrencyUseCase(currencyService: currencyService)
	}
	
	func makeLastUsedCurrencyOptionsUseCase(
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) -> LastUsedCurrencyOptionsUseCase {
		let localStorageService = LocalStorageServiceMock(
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
		return LastUsedCurrencyOptionsUseCase(localStorageService: localStorageService)
	}
}

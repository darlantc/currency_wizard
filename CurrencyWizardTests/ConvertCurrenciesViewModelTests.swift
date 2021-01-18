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
	
	func test_didWantToChangeFromCurrencyOption_shouldCallCallback() {
		var count = 0
		var responseToCallback = usdCurrencyOption
		
		let sut = makeSUT(selectCurrencyOption: { (completion) in
			count += 1
			completion(responseToCallback)
		})
		XCTAssertEqual(count, 0)
		XCTAssertNil(sut.fromCurrencyOption.value)
		
		sut.didWantToChangeFromCurrencyOption()
		XCTAssertEqual(sut.fromCurrencyOption.value, usdCurrencyOption)
		XCTAssertEqual(count, 1)
		
		responseToCallback = eurCurrencyOption
		sut.didWantToChangeFromCurrencyOption()
		XCTAssertEqual(sut.fromCurrencyOption.value, eurCurrencyOption)
		XCTAssertEqual(count, 2)
	}
	
	func test_didWantToChangeToCurrencyOption_shouldCallCallback() {
		var count = 0
		var responseToCallback = eurCurrencyOption
		
		let sut = makeSUT(selectCurrencyOption: { (completion) in
			count += 1
			completion(responseToCallback)
		})
		XCTAssertEqual(count, 0)
		XCTAssertNil(sut.toCurrencyOption.value)
		
		sut.didWantToChangeToCurrencyOption()
		XCTAssertEqual(sut.toCurrencyOption.value, eurCurrencyOption)
		XCTAssertEqual(count, 1)
		
		responseToCallback = usdCurrencyOption
		sut.didWantToChangeToCurrencyOption()
		XCTAssertEqual(sut.toCurrencyOption.value, usdCurrencyOption)
		XCTAssertEqual(count, 2)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(
		selectCurrencyOption: @escaping ((CurrencyOption) -> Void) -> Void = { _ in },
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
			lastUsedCurrencyOptionsUseCase: lastUsedCurrencyOptionsUseCase,
			selectCurrencyOption: selectCurrencyOption
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

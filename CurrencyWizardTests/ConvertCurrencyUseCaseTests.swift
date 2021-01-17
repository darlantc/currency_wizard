//
//  ConvertCurrencyUseCaseTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class ConvertCurrencyUseCaseTests: XCTestCase {
	func test_initSUT_withoutExchangeRateValue_returnsZero() {
		var response: Double = 0
		
		let sut = makeSUT()
		sut.convert(value: 100, from: usdCurrencyOption, to: eurCurrencyOption) { (convertedValue) in
			response = convertedValue
		}
		
		XCTAssertEqual(response, 0)
	}
	
	func test_initSUT_withExchangeRateValue_returnsConvertedValue() {
		assertConvertedValuesWith(exchangeRateValue: 0)
		assertConvertedValuesWith(exchangeRateValue: 0.827849)
		assertConvertedValuesWith(exchangeRateValue: 1.0)
		assertConvertedValuesWith(exchangeRateValue: 10180.000355)
		assertConvertedValuesWith(exchangeRateValue: 2.7620287e-5)
	}
	
	func assertConvertedValuesWith(exchangeRateValue: Double) {
		let valuesToTest = [0, 1, 100, Double.greatestFiniteMagnitude ]
				
		for value in valuesToTest {
			assertConvert(
				value: value,
				with: exchangeRateValue,
				for: makeSUT(exchangeRateValue: exchangeRateValue))
		}
	}
	
	func assertConvert(
		value: Double,
		with exchangeRateValue: Double,
		for sut: ConvertCurrencyUseCase
	) {
		var response: Double = 0
		func completionCallback(convertedValue: Double) -> Void {
			response = convertedValue
		}
		
		sut.convert(
			value: value,
			from: usdCurrencyOption,
			to: eurCurrencyOption,
			completion: completionCallback)
		XCTAssertEqual(response, value * exchangeRateValue)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(exchangeRateValue: Double = 0) -> ConvertCurrencyUseCase {
		let currencyService = CurrencyServiceMock(exchangeRateValue: exchangeRateValue)
		return ConvertCurrencyUseCase(currencyService: currencyService)
	}
}

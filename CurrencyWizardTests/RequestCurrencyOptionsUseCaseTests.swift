//
//  RequestCurrencyOptionsUseCaseTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class RequestCurrencyOptionsUseCaseTests: XCTestCase {
	func test_initSUT_withoutOptions_returnsError() {
		var responseError: String?
		var responseOptions = [CurrencyOption]()

		let sut = makeSUT()
		sut.request { (options, error) in
			responseError = error
			responseOptions = options
		}
		
		XCTAssertNotNil(responseError)
		XCTAssertTrue(responseOptions.isEmpty)
	}
	
	func test_requestCurrencyOptions_shouldCallRequestFromCurrencyService() {
		var responseError: String?
		var responseOptions = [CurrencyOption]()
		
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		sut.request { (options, error) in
			responseOptions = options
			responseError = error
		}
		
		XCTAssertNil(responseError)
		XCTAssertFalse(responseOptions.isEmpty)
		XCTAssertEqual(responseOptions.first!, usdCurrencyOption)
		XCTAssertEqual(responseOptions.last!, eurCurrencyOption)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(options: [CurrencyOption] = []) -> RequestCurrencyOptionsUseCase {
		let currencyService = CurrencyServiceMock(options: options)
		return RequestCurrencyOptionsUseCase(currencyService: currencyService)
	}
}

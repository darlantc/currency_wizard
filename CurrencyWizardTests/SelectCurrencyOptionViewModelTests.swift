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
	func test_initSUT_withHeaderText_shouldHaveHeaderText() {
		let sut = makeSUT(headerText: "Please select")
		XCTAssertEqual(sut.headerText, "Please select")
	}
	
	func test_initSUT_shouldHaveEmptyList() {
		let sut = makeSUT()
		XCTAssertTrue(sut.currencyOptionsList.value.isEmpty)
	}
	
	func test_requestCurrencyOptions_noneAvailableFromCurrencyService_shouldHaveEmptyList() {
		let sut = makeSUT(options: [])
		sut.requestCurrencyOptions()
		XCTAssertTrue(sut.currencyOptionsList.value.isEmpty)
	}
	
	func test_requestCurrencyOptions_twoAvailableFromCurrencyService_shouldReturnBoth() {
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		sut.requestCurrencyOptions()
		XCTAssertEqual(sut.currencyOptionsList.value.count, 2)
		XCTAssertEqual(sut.currencyOptionsList.value.first!, usdCurrencyOption)
		XCTAssertEqual(sut.currencyOptionsList.value.last!, eurCurrencyOption)
	}
	
	func test_withoutOptionsFromCurrencyService_withDidFinishCallback_shouldNotCall() {
		var count = 0
		
		let sut = makeSUT(options: [], didFinish: { _ in count += 1 })
		sut.requestCurrencyOptions()
		sut.didSelect(at: 0)
		sut.didFinishWithSelected()
		
		XCTAssertEqual(count, 0)
	}
	
	func test_withOptionsFromCurrencyServiceAndDidFinishCallback_didSelectAndDidFinish_shouldCallWhenNecessary() {
		var count = 0
		var selectedCurrencyOption: CurrencyOption? = nil
		
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption], didFinish: { currencyOption in
			count += 1
			selectedCurrencyOption = currencyOption
		})
		sut.requestCurrencyOptions()
		sut.didSelect(at: 0)
		sut.didFinishWithSelected()
		XCTAssertEqual(count, 1)
		XCTAssertEqual(selectedCurrencyOption, usdCurrencyOption)
		
		sut.didSelect(at: 1)
		sut.didFinishWithSelected()
		XCTAssertEqual(count, 2)
		XCTAssertEqual(selectedCurrencyOption, eurCurrencyOption)
		
		// Invalid index, should be ignored and assert equal last selected
		sut.didSelect(at: 2)
		sut.didFinishWithSelected()
		XCTAssertEqual(count, 2)
		XCTAssertEqual(selectedCurrencyOption, eurCurrencyOption)
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(
		headerText: String = "",
		options: [CurrencyOption] = [],
		didFinish: @escaping (CurrencyOption) -> Void = { _ in }
	) -> SelectCurrencyOptionViewModel {
		let currencyService = CurrencyServiceMock(options: options)
		let requestCurrencyOptionsUseCase = RequestCurrencyOptionsUseCase(currencyService: currencyService)
		return SelectCurrencyOptionViewModel(
			headerText: headerText,
			requestCurrencyOptionsUseCase: requestCurrencyOptionsUseCase,
			didFinish: didFinish
		)
	}
}

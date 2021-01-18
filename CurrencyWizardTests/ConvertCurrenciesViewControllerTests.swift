//
//  ConvertCurrenciesViewControllerTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import XCTest
@testable import CurrencyWizard

class ConvertCurrenciesViewControllerTests: UIViewControllerXCTestCase {
	func test_initSUT_withoutLastUsed_currencyOptionButtonsShouldDisplaySelectString() {
		let sut = makeSUT()
		
		XCTAssertEqual(sut.fromCurrencyOptionButton.title(for: .normal), "Selecione...")
		XCTAssertEqual(sut.toCurrencyOptionButton.title(for: .normal), "Selecione...")
	}
	
	func test_initSUT_withLastUsed_currencyOptionButtonsShouldDisplaySelectedCurrencyOption() {
		let sut = makeSUT(
			lastUsedFromCurrencyOption: usdCurrencyOption,
			lastUsedToCurrencyOption: eurCurrencyOption
		)
		
		XCTAssertEqual(sut.fromCurrencyOptionButton.title(for: .normal), "\(usdCurrencyOption.name) (\(usdCurrencyOption.id))")
		XCTAssertEqual(sut.toCurrencyOptionButton.title(for: .normal), "\(eurCurrencyOption.name) (\(eurCurrencyOption.id))")
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
	
	func makeSUT(
		selectCurrencyOption: @escaping ((CurrencyOption) -> Void) -> Void = { _ in },
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) -> ConvertCurrenciesViewController {
		let viewModel = makeViewModel(
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
		let sut = ConvertCurrenciesViewController(viewModel: viewModel)
		let _ = sut.view
		
		return sut
	}
	
	func makeViewModel(
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

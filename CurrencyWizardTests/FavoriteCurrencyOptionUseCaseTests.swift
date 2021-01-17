//
//  FavoriteCurrencyOptionUseCase.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class FavoriteCurrencyOptionUseCaseTests: XCTestCase {
	func test_initSUT_withoutIdsList_returnFalse() {
		let sut = makeSUT(idsList: [])
		
		XCTAssertFalse(sut.isFavorited(currencyOption: usdCurrencyOption))
		XCTAssertFalse(sut.isFavorited(currencyOption: eurCurrencyOption))
	}
	
	func test_initSUT_withIdsList_returnTrue() {
		let sut = makeSUT(idsList: [usdCurrencyOption.id, eurCurrencyOption.id])
		
		XCTAssertTrue(sut.isFavorited(currencyOption: usdCurrencyOption))
		XCTAssertTrue(sut.isFavorited(currencyOption: eurCurrencyOption))
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(idsList: [String] = []) -> FavoriteCurrencyOptionUseCase {
		let localStorageService = LocalStorageServiceMock(idsList: idsList)
		return FavoriteCurrencyOptionUseCase(localStorageService: localStorageService)
	}
}

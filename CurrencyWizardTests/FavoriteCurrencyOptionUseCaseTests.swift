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
		let sut = makeSUT(localStorageServiceIdsList: [])
		
		XCTAssertFalse(sut.isFavorited(currencyOption: usdCurrencyOption))
		XCTAssertFalse(sut.isFavorited(currencyOption: eurCurrencyOption))
	}
	
	func test_initSUT_withIdsList_returnTrue() {
		let sut = makeSUT(localStorageServiceIdsList: [usdCurrencyOption.id, eurCurrencyOption.id])
		
		XCTAssertTrue(sut.isFavorited(currencyOption: usdCurrencyOption))
		XCTAssertTrue(sut.isFavorited(currencyOption: eurCurrencyOption))
	}
	
	func test_didFavoriteCurrencyOption_shouldBeFavorited() {
		var localStorageServiceDidCallListener = [String]()
		
		let sut = makeSUT(localStorageServiceIdsList: []) { localStorageServiceDidCallListener.append($0) }
		XCTAssertFalse(sut.isFavorited(currencyOption: usdCurrencyOption))
		
		sut.favorite(currencyOption: usdCurrencyOption)
		XCTAssertTrue(sut.isFavorited(currencyOption: usdCurrencyOption))
		XCTAssertEqual(localStorageServiceDidCallListener, ["requestFavoriteCurrencyOptionIds", "favorite(currencyOption:)"])
		
		sut.favorite(currencyOption: eurCurrencyOption)
		XCTAssertTrue(sut.isFavorited(currencyOption: eurCurrencyOption))
		XCTAssertEqual(localStorageServiceDidCallListener, ["requestFavoriteCurrencyOptionIds", "favorite(currencyOption:)", "favorite(currencyOption:)"])
	}
	
	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(localStorageServiceIdsList: [String] = [], localStorageServiceDidCallListener: ((String) -> Void)? = nil) -> FavoriteCurrencyOptionUseCase {
		let localStorageService = LocalStorageServiceMock(
			idsList: localStorageServiceIdsList,
			didCallListener: localStorageServiceDidCallListener
		)
		return FavoriteCurrencyOptionUseCase(localStorageService: localStorageService)
	}
}

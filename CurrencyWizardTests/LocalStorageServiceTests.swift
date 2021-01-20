//
//  LocalStorageServiceTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

class LocalStorageServiceTests: XCTestCase {
	func test_initSUT_shouldNotRequestAnything() {
		let sut = makeSUT()
		XCTAssertEqual(sut.internalCalls, [])
	}
	
	func test_requestCurrencyOptions_shouldCallMethod() {
		var requestResponse = [[CurrencyOption]]()
		
		func requestCallback(currencyOptions: [CurrencyOption]) -> Void {
			requestResponse.append(currencyOptions)
		}
		
		let sut = makeSUT(currencyOptions: [usdCurrencyOption, eurCurrencyOption])
		sut.requestCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestResponse, [[usdCurrencyOption, eurCurrencyOption]])
		XCTAssertEqual(sut.internalCalls, ["requestCurrencyOptions"])
		
		sut.requestCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestResponse, [[usdCurrencyOption, eurCurrencyOption], [usdCurrencyOption, eurCurrencyOption]])
		XCTAssertEqual(sut.internalCalls, ["requestCurrencyOptions", "requestCurrencyOptions"])
	}
	
	func test_requestExchangeRateQuotes_shouldCallMethod() {
		var requestResponse = [[ExchangeRateQuote]]()
		
		func requestCallback(exchangeRateQuotes: [ExchangeRateQuote]) -> Void {
			requestResponse.append(exchangeRateQuotes)
		}
		
		let sut = makeSUT(exchangeRateQuotes: [exchangeRateQuote1, exchangeRateQuote2])
		sut.requestExchangeRateQuotes(completion: requestCallback)
		XCTAssertEqual(requestResponse, [[exchangeRateQuote1, exchangeRateQuote2]])
		XCTAssertEqual(sut.internalCalls, ["requestExchangeRateQuotes"])
		
		sut.requestExchangeRateQuotes(completion: requestCallback)
		XCTAssertEqual(requestResponse, [[exchangeRateQuote1, exchangeRateQuote2], [exchangeRateQuote1, exchangeRateQuote2]])
		XCTAssertEqual(sut.internalCalls, ["requestExchangeRateQuotes", "requestExchangeRateQuotes"])
	}
	
	func test_requestLastUsedCurrencyOptions_shouldCallMethod() {
		var requestCount = 0
		
		func requestCallback(lastUsedOptions: (from: CurrencyOption, to: CurrencyOption)?) -> Void {
			requestCount += 1
		}
		
		let sut = makeSUT()
		sut.requestLastUsedCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(sut.internalCalls, ["requestLastUsedCurrencyOptions"])
		
		sut.requestLastUsedCurrencyOptions(completion: requestCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(sut.internalCalls, ["requestLastUsedCurrencyOptions", "requestLastUsedCurrencyOptions"])
	}
	
	func test_withoutLastUsedData_requestLastUsedCurrencyOptions_shouldReturnNil() {
		var response: (from: CurrencyOption, to: CurrencyOption)? = nil
		
		let sut = makeSUT()
		sut.requestLastUsedCurrencyOptions { response = $0 }
		
		XCTAssertNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNil(sut.lastUsedToCurrencyOption)
		XCTAssertNil(response)
	}
	
	func test_withLastUsedData_requestLastUsedCurrencyOptions_shouldReturnValidData() {
		var response: (from: CurrencyOption, to: CurrencyOption)? = nil
		
		let sut = makeSUT(lastUsedFromCurrencyOption: usdCurrencyOption, lastUsedToCurrencyOption: eurCurrencyOption)
		sut.requestLastUsedCurrencyOptions { response = $0 }
		
		XCTAssertNotNil(sut.lastUsedFromCurrencyOption)
		XCTAssertNotNil(sut.lastUsedToCurrencyOption)
		XCTAssertEqual(response?.from.id, usdCurrencyOption.id)
		XCTAssertEqual(response?.to.id, eurCurrencyOption.id)
	}
	
	func test_noOneIsFavorited_requestFavoriteCurrencyOptionIds_returnEmptyList() {
		var response = [String]()
		
		let sut = makeSUT(idsList: [])
		sut.requestFavoriteCurrencyOptionIds { response = $0 }
		XCTAssertEqual(response, [])
	}
	
	func test_hasFavorites_requestFavoriteCurrencyOptionIds_returnFavoriteIds() {
		var requestCount = 0
		var response = [String]()
		
		func completionCallback(ids: [String]) -> Void {
			requestCount += 1
			response = ids
		}
		
		let sut = makeSUT(idsList: [usdCurrencyOption.id, eurCurrencyOption.id])
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(response, [usdCurrencyOption.id, eurCurrencyOption.id])
		XCTAssertEqual(sut.internalCalls, ["requestFavoriteCurrencyOptionIds"])
		
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(response, [usdCurrencyOption.id, eurCurrencyOption.id])
		XCTAssertEqual(sut.internalCalls, ["requestFavoriteCurrencyOptionIds", "requestFavoriteCurrencyOptionIds"])
	}

	func test_favoriteCurrencyOption_returnIdAsFavorite() {
		var requestResponse = [String]()
		
		func completionCallback(ids: [String]) -> Void {
			requestResponse = ids
		}
		
		let sut = makeSUT(idsList: [])
		
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertFalse(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertFalse(requestResponse.contains(eurCurrencyOption.id))
		
		sut.favorite(currencyOption: usdCurrencyOption)
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertTrue(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertFalse(requestResponse.contains(eurCurrencyOption.id))
		XCTAssertEqual(sut.internalCalls, [
			"requestFavoriteCurrencyOptionIds",
			"favorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds"
		])
		
		sut.favorite(currencyOption: eurCurrencyOption)
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertTrue(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertTrue(requestResponse.contains(eurCurrencyOption.id))
		XCTAssertEqual(sut.internalCalls, [
			"requestFavoriteCurrencyOptionIds",
			"favorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds",
			"favorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds"
		])
	}
	
	func test_removeFavoriteCurrencyOption_shouldRemoveIdAsFavorite() {
		var requestResponse = [String]()
		
		func completionCallback(ids: [String]) -> Void {
			requestResponse = ids
		}
		
		let sut = makeSUT(idsList: [usdCurrencyOption.id, eurCurrencyOption.id])
		
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertTrue(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertTrue(requestResponse.contains(eurCurrencyOption.id))
		
		sut.removeFavorite(currencyOption: usdCurrencyOption)
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertFalse(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertTrue(requestResponse.contains(eurCurrencyOption.id))
		XCTAssertEqual(sut.internalCalls, [
			"requestFavoriteCurrencyOptionIds",
			"removeFavorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds"
		])
		
		sut.removeFavorite(currencyOption: eurCurrencyOption)
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertFalse(requestResponse.contains(usdCurrencyOption.id))
		XCTAssertFalse(requestResponse.contains(eurCurrencyOption.id))
		XCTAssertEqual(sut.internalCalls, [
			"requestFavoriteCurrencyOptionIds",
			"removeFavorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds",
			"removeFavorite(currencyOption:)",
			"requestFavoriteCurrencyOptionIds"
		])
	}
	
	func test_saveCurrencyOptionsList_shouldCallIt() {
		let sut = makeSUT()
		XCTAssertEqual(sut.internalCalls, [])
		
		sut.save(currencyOptionsList: [usdCurrencyOption, eurCurrencyOption])
		XCTAssertEqual(sut.internalCalls, ["save(currencyOptionsList:"])
		
		sut.save(currencyOptionsList: [usdCurrencyOption, eurCurrencyOption])
		XCTAssertEqual(sut.internalCalls, ["save(currencyOptionsList:", "save(currencyOptionsList:"])
	}
	
	func test_saveExchangeRates_shouldCallIt() {
		let sut = makeSUT()
		XCTAssertEqual(sut.internalCalls, [])
		
		sut.save(exchangeRates: [exchangeRateQuote1])
		XCTAssertEqual(sut.internalCalls, ["save(exchangeRates:"])
		
		sut.save(exchangeRates: [exchangeRateQuote2])
		XCTAssertEqual(sut.internalCalls, ["save(exchangeRates:", "save(exchangeRates:"])
	}
	
	// MARK: Helpers
	private func makeSUT(
		idsList: [String] = [],
		currencyOptions: [CurrencyOption] = [],
		exchangeRateQuotes: [ExchangeRateQuote] = [],
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) -> LocalStorageServiceStub {
		return LocalStorageServiceStub(
			idsList,
			currencyOptions: currencyOptions,
			exchangeRateQuotes: exchangeRateQuotes,
			lastUsedFromCurrencyOption: lastUsedFromCurrencyOption,
			lastUsedToCurrencyOption: lastUsedToCurrencyOption
		)
	}
}

private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")
private let exchangeRateQuote1 = ExchangeRateQuote(id: "USDEUR", exchangeRate: 0.125)
private let exchangeRateQuote2 = ExchangeRateQuote(id: "USDBRL", exchangeRate: 0.855)

private class LocalStorageServiceStub: LocalStorageService {
	private var currencyOptions: [CurrencyOption]
	private var exchangeRateQuotes: [ExchangeRateQuote]
	private var idsList: [String]
	fileprivate var currencyOptionsList = [CurrencyOption]()
	private (set) var lastUsedFromCurrencyOption: CurrencyOption?
	private (set) var lastUsedToCurrencyOption: CurrencyOption?
	
	init(
		_ idsList: [String],
		currencyOptions: [CurrencyOption] = [],
		exchangeRateQuotes: [ExchangeRateQuote] = [],
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) {
		self.idsList = idsList
		self.currencyOptions = currencyOptions
		self.exchangeRateQuotes = exchangeRateQuotes
		self.lastUsedFromCurrencyOption = lastUsedFromCurrencyOption
		self.lastUsedToCurrencyOption = lastUsedToCurrencyOption
	}
	
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void) {
		self.didCall(function: "requestCurrencyOptions")
		completion(self.currencyOptions)
	}
	func requestExchangeRateQuotes(completion: @escaping([ExchangeRateQuote]) -> Void) {
		self.didCall(function: "requestExchangeRateQuotes")
		completion(self.exchangeRateQuotes)
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		self.didCall(function: "requestLastUsedCurrencyOptions")
		
		guard let from = self.lastUsedFromCurrencyOption, let to = self.lastUsedToCurrencyOption else {
			completion(nil)
			return
		}
		completion((from, to))
	}
	
	func saveLastUsedCurrencyOptions(from fromCurrencyOption: CurrencyOption, to toCurrencyOption: CurrencyOption) {
		self.lastUsedFromCurrencyOption = fromCurrencyOption
		self.lastUsedToCurrencyOption = toCurrencyOption
	}
	
	func save(currencyOptionsList: [CurrencyOption]) {
		self.currencyOptionsList = currencyOptionsList
		self.didCall(function: "save(currencyOptionsList:")
	}
	
	func save(exchangeRates: [ExchangeRateQuote]) {
		self.didCall(function: "save(exchangeRates:")
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		self.didCall(function: "requestFavoriteCurrencyOptionIds")
		completion(self.idsList)
	}
	
	func favorite(currencyOption: CurrencyOption) {
		self.didCall(function: "favorite(currencyOption:)")
		self.idsList.append(currencyOption.id)
	}
	
	func removeFavorite(currencyOption: CurrencyOption) {
		self.didCall(function: "removeFavorite(currencyOption:)")
		self.idsList = self.idsList.filter { $0 != currencyOption.id }
	}

	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}


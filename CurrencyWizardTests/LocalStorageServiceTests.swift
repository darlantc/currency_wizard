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
	
	func test_requestLastUsedCurrencyOptions_shouldReturnValidData() {
		var response: (from: CurrencyOption, to: CurrencyOption)? = nil
		
		let sut = makeSUT()
		sut.requestLastUsedCurrencyOptions { response = $0 }
		
		XCTAssertEqual(response?.from.id, "USD")
		XCTAssertEqual(response?.to.id, "EUR")
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
		
		let sut = makeSUT(idsList: ["USD", "EUR"])
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertEqual(requestCount, 1)
		XCTAssertEqual(response, ["USD", "EUR"])
		XCTAssertEqual(sut.internalCalls, ["requestFavoriteCurrencyOptionIds"])
		
		sut.requestFavoriteCurrencyOptionIds(completion: completionCallback)
		XCTAssertEqual(requestCount, 2)
		XCTAssertEqual(response, ["USD", "EUR"])
		XCTAssertEqual(sut.internalCalls, ["requestFavoriteCurrencyOptionIds", "requestFavoriteCurrencyOptionIds"])
	}

	
	// MARK: Helpers
	private func makeSUT(idsList: [String] = []) -> LocalStorageServiceStub {
		return LocalStorageServiceStub(idsList)
	}
}

private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

private class LocalStorageServiceStub: LocalStorageService {
	private let idsList: [String]
	
	init(_ idsList: [String]) {
		self.idsList = idsList
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		self.didCall(function: "requestLastUsedCurrencyOptions")
		completion((usdCurrencyOption, eurCurrencyOption))
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		self.didCall(function: "requestFavoriteCurrencyOptionIds")
		completion(self.idsList)
	}

	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}


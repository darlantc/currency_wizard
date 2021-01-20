//
//  LocalStorageServiceMock.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
@testable import CurrencyWizard

class LocalStorageServiceMock: LocalStorageService {
	var currencyOptionsList = [CurrencyOption]()
	private var idsList: [String]
	private let didCallListener: ((String) -> Void)?
	private var lastUsedFromCurrencyOption: CurrencyOption?
	private var lastUsedToCurrencyOption: CurrencyOption?
	
	init(
		idsList: [String] = [],
		didCallListener: ((String) -> Void)? = nil,
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) {
		self.idsList = idsList
		self.didCallListener = didCallListener
		self.lastUsedFromCurrencyOption = lastUsedFromCurrencyOption
		self.lastUsedToCurrencyOption = lastUsedToCurrencyOption
	}
	
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void) {
		self.didCallListener?("requestCurrencyOptions")
		completion([])
	}
	func requestExchangeRateQuotes(completion: @escaping([ExchangeRateQuote]) -> Void) {
		self.didCallListener?("requestExchangeRateQuotes")
		completion([])
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		self.didCallListener?("requestLastUsedCurrencyOptions")
		
		guard let from = self.lastUsedFromCurrencyOption, let to = self.lastUsedToCurrencyOption else {
			completion(nil)
			return
		}
		completion((from, to))
	}
	
	func saveLastUsedCurrencyOptions(from fromCurrencyOption: CurrencyOption, to toCurrencyOption: CurrencyOption) {
		self.didCallListener?("saveLastUsedCurrencyOptions")

		self.lastUsedFromCurrencyOption = fromCurrencyOption
		self.lastUsedToCurrencyOption = toCurrencyOption
	}
	
	func save(currencyOptionsList: [CurrencyOption]) {
		self.currencyOptionsList = currencyOptionsList
		self.didCallListener?("save(currencyOptionsList:)")
	}
	
	func save(exchangeRates: [ExchangeRateQuote]) {
		self.didCallListener?("save(exchangeRates:)")
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		self.didCallListener?("requestFavoriteCurrencyOptionIds")
		completion(self.idsList)
	}
	
	func favorite(currencyOption: CurrencyOption) {
		self.didCallListener?("favorite(currencyOption:)")
		self.idsList.append(currencyOption.id)
	}
	
	func removeFavorite(currencyOption: CurrencyOption) {
		self.didCallListener?("removeFavorite(currencyOption:)")
		self.idsList = self.idsList.filter { $0 != currencyOption.id }
	}
}

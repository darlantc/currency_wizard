//
//  File.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 19/01/21.
//

import Foundation

private enum StorageKeys: String {
	case currencyOptionsList = "currencyOptionsList"
	case favoriteCurrencyOptionIds = "favoriteCurrencyOptionIds"
	case exchangeRates = "exchangeRates"
	case lastUsedFromCurrencyOption = "lastUsedFromCurrencyOption"
	case lastUsedToCurrencyOption = "lastUsedToCurrencyOption"
}

final class UserDefaultsStorageService: LocalStorageService {
	private var userDefaults: UserDefaults
	var currencyOptionsList = [CurrencyOption]()
	
	var favoriteCurrencyOptionIds = [String]() {
		didSet {
			self.save(self.favoriteCurrencyOptionIds, forKey: StorageKeys.favoriteCurrencyOptionIds)
		}
	}
	
	init(userDefaults: UserDefaults = UserDefaults.standard) {
		self.userDefaults = userDefaults
	}
	
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void) {
		if self.currencyOptionsList.isEmpty,
		   let data = self.getData(forKey: StorageKeys.currencyOptionsList),
		   let savedList = try? PropertyListDecoder().decode(
			Array<CurrencyOption>.self, from: data
		   ) {
			self.currencyOptionsList = savedList
		}
		
		completion(self.currencyOptionsList)
	}
	
	func requestExchangeRateQuotes(completion: @escaping ([ExchangeRateQuote]) -> Void) {
		var exchangeRates = [ExchangeRateQuote]()
		if let data = self.getData(forKey: StorageKeys.exchangeRates),
		   let savedList = try? PropertyListDecoder().decode(
			Array<ExchangeRateQuote>.self, from: data
		   ) {
			exchangeRates = savedList
		}
		
		completion(exchangeRates)
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		let decoder = JSONDecoder()

		guard let savedFrom = self.getData(forKey: StorageKeys.lastUsedFromCurrencyOption),
			  let lastUsedFrom = try? decoder.decode(CurrencyOption.self, from: savedFrom),
			  let savedTo = self.getData(forKey: StorageKeys.lastUsedToCurrencyOption),
			  let lastUsedTo = try? decoder.decode(CurrencyOption.self, from: savedTo)
		else {
			completion(nil)
			return
		}
		
		completion((lastUsedFrom, lastUsedTo))
	}
	
	func saveLastUsedCurrencyOptions(from fromCurrencyOption: CurrencyOption, to toCurrencyOption: CurrencyOption) {
		let encoder = JSONEncoder()
		guard let encodedFrom = try? encoder.encode(fromCurrencyOption),
			  let encodedTo = try? encoder.encode(toCurrencyOption) else {
			return
		}
		self.save(encodedFrom, forKey: StorageKeys.lastUsedFromCurrencyOption)
		self.save(encodedTo, forKey: StorageKeys.lastUsedToCurrencyOption)
	}
	
	func save(currencyOptionsList: [CurrencyOption]) {
		self.currencyOptionsList = currencyOptionsList
		self.save(try? PropertyListEncoder().encode(currencyOptionsList), forKey: StorageKeys.currencyOptionsList)
	}
	
	func save(exchangeRates: [ExchangeRateQuote]) {
		self.save(try? PropertyListEncoder().encode(exchangeRates), forKey: StorageKeys.exchangeRates)
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		var list = [String]()
		if let optionIds = self.getArray(forKey: StorageKeys.favoriteCurrencyOptionIds) as? [String] {
			list = optionIds
		}
		self.favoriteCurrencyOptionIds = list
		completion(list)
	}
	
	func favorite(currencyOption: CurrencyOption) {
		self.favoriteCurrencyOptionIds.append(currencyOption.id)
	}
	
	func removeFavorite(currencyOption: CurrencyOption) {
		self.favoriteCurrencyOptionIds = self.favoriteCurrencyOptionIds.filter { $0 != currencyOption.id }
	}
	
	private func save(_ value: Any?, forKey key: StorageKeys) {
		self.userDefaults.setValue(value, forKey: key.rawValue)
	}
	
	private func getData(forKey key: StorageKeys) -> Data? {
		self.userDefaults.data(forKey: key.rawValue)
	}
	
	private func remove(key: StorageKeys) {
		self.userDefaults.removeObject(forKey: key.rawValue)
	}
	
	private func getDictionary(forKey key: StorageKeys) -> [String: Any]? {
		return self.userDefaults.dictionary(forKey: key.rawValue)
	}
	
	private func getArray(forKey key: StorageKeys) -> [Any]? {
		return self.userDefaults.array(forKey: key.rawValue)
	}
}

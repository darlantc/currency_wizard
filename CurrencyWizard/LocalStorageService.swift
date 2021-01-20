//
//  LocalStorageService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

protocol LocalStorageService {
	var currencyOptionsList: [CurrencyOption] { get }
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void)
	func saveLastUsedCurrencyOptions(from fromCurrencyOption: CurrencyOption, to toCurrencyOption: CurrencyOption)
	func save(currencyOptionsList: [CurrencyOption])
	func save(exchangeRates: [String: Double])
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void)
	func favorite(currencyOption: CurrencyOption)
	func removeFavorite(currencyOption: CurrencyOption)
}

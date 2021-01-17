//
//  LocalStorageService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

protocol LocalStorageService {
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void)
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void)
	func favorite(currencyOption: CurrencyOption)
}

//
//  LocalStorageServiceMock.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
@testable import CurrencyWizard

class LocalStorageServiceMock: LocalStorageService {
	private var idsList: [String]
	private let didCallListener: ((String) -> Void)?
	
	init(idsList: [String], didCallListener: ((String) -> Void)? = nil) {
		self.idsList = idsList
		self.didCallListener = didCallListener
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		self.didCallListener?("requestLastUsedCurrencyOptions")
		completion(nil)
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

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
	
	init(idsList: [String] = []) {
		self.idsList = idsList
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		completion(nil)
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		completion(self.idsList)
	}
	
	func favorite(currencyOption: CurrencyOption) {
		self.idsList.append(currencyOption.id)
	}
	
	func removeFavorite(currencyOption: CurrencyOption) {
		self.idsList = self.idsList.filter { $0 != currencyOption.id }
	}
}

//
//  FavoriteCurrencyOptionUseCase.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class FavoriteCurrencyOptionUseCase {
	private let localStorageService: LocalStorageService
	private var favoritedIdsList = [String]()
	
	init(localStorageService: LocalStorageService) {
		self.localStorageService = localStorageService
		
		self.localStorageService.requestFavoriteCurrencyOptionIds { (idsList) in
			self.favoritedIdsList = idsList
		}
	}
	
	func isFavorited(currencyOption: CurrencyOption) -> Bool {
		return self.favoritedIdsList.contains(currencyOption.id)
	}
}

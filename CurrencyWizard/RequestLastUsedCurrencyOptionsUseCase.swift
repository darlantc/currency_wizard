//
//  RequestLastUsedCurrencyOptionsUseCase.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class RequestLastUsedCurrencyOptionsUseCase {
	private let localStorageService: LocalStorageService
	var lastUsedFromCurrencyOption: CurrencyOption?
	var lastUsedToCurrencyOption: CurrencyOption?
	
	init(localStorageService: LocalStorageService) {
		self.localStorageService = localStorageService
		
		localStorageService.requestLastUsedCurrencyOptions { [weak self] (lastUsed) in
			guard let weakSelf = self, let lastUsed = lastUsed else { return }
			weakSelf.lastUsedFromCurrencyOption = lastUsed.from
			weakSelf.lastUsedToCurrencyOption = lastUsed.to
		}
	}
}

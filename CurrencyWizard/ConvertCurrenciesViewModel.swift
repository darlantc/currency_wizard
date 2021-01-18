//
//  ConvertCurrenciesViewModel.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import Foundation

final class ConvertCurrenciesViewModel {
	private let convertCurrencyUseCase: ConvertCurrencyUseCase
	private let lastUsedCurrencyOptionsUseCase: LastUsedCurrencyOptionsUseCase
	
	var fromCurrencyOption: Observable<CurrencyOption?> = Observable(nil)
	var toCurrencyOption: Observable<CurrencyOption?> = Observable(nil)

	init(
		convertCurrencyUseCase: ConvertCurrencyUseCase,
		lastUsedCurrencyOptionsUseCase: LastUsedCurrencyOptionsUseCase
	) {
		self.convertCurrencyUseCase = convertCurrencyUseCase
		self.lastUsedCurrencyOptionsUseCase = lastUsedCurrencyOptionsUseCase
		
		self.getLastUsedFrom(useCase: lastUsedCurrencyOptionsUseCase)
	}
	
	func swapCurrencyOptions() {
		let backupFrom = self.fromCurrencyOption.value
		self.setFrom(currencyOption: self.toCurrencyOption.value)
		self.setTo(currencyOption: backupFrom)
	}
	
	private func getLastUsedFrom(useCase: LastUsedCurrencyOptionsUseCase) {
		self.setFrom(currencyOption: useCase.lastUsedFromCurrencyOption)
		self.setTo(currencyOption: useCase.lastUsedToCurrencyOption)
	}
	
	private func setFrom(currencyOption: CurrencyOption?) {
		self.fromCurrencyOption.value = currencyOption
	}
	
	private func setTo(currencyOption: CurrencyOption?) {
		self.toCurrencyOption.value = currencyOption
	}
}

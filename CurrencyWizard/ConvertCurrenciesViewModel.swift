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
	private let selectCurrencyOption: ((CurrencyOption) -> Void) -> Void
	
	var fromCurrencyOption: Observable<CurrencyOption?> = Observable(nil)
	var toCurrencyOption: Observable<CurrencyOption?> = Observable(nil)
	var convertedValue: Observable<Double?> = Observable(nil)

	init(
		convertCurrencyUseCase: ConvertCurrencyUseCase,
		lastUsedCurrencyOptionsUseCase: LastUsedCurrencyOptionsUseCase,
		selectCurrencyOption: @escaping ((CurrencyOption) -> Void) -> Void
	) {
		self.convertCurrencyUseCase = convertCurrencyUseCase
		self.lastUsedCurrencyOptionsUseCase = lastUsedCurrencyOptionsUseCase
		self.selectCurrencyOption = selectCurrencyOption
		
		self.getLastUsedFrom(useCase: lastUsedCurrencyOptionsUseCase)
	}
	
	func swapCurrencyOptions() {
		let backupFrom = self.fromCurrencyOption.value
		self.setFrom(currencyOption: self.toCurrencyOption.value)
		self.setTo(currencyOption: backupFrom)
	}
	
	func didWantToChangeFromCurrencyOption() {
		self.selectCurrencyOption { self.setFrom(currencyOption: $0) }
	}
	
	func didWantToChangeToCurrencyOption() {
		self.selectCurrencyOption { self.setTo(currencyOption: $0) }
	}
	
	func convert(value: Double) {
		guard let from = self.fromCurrencyOption.value, let to = self.toCurrencyOption.value else { return }
	
		self.convertCurrencyUseCase.convert(value: value, from: from, to: to) { (convertedValue) in
			self.convertedValue.value = convertedValue
		}
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

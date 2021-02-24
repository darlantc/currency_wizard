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
	private let selectCurrencyOption: (@escaping (CurrencyOption) -> Void) -> Void
	
	var fromCurrencyOption: Observable<CurrencyOption?> = Observable(nil)
	var toCurrencyOption: Observable<CurrencyOption?> = Observable(nil)
	var convertedValue: Observable<Double?> = Observable(nil)
	
	private var currentValue: Double

	init(
		convertCurrencyUseCase: ConvertCurrencyUseCase,
		lastUsedCurrencyOptionsUseCase: LastUsedCurrencyOptionsUseCase,
		selectCurrencyOption: @escaping (@escaping (CurrencyOption) -> Void) -> Void
	) {
		self.currentValue = 0
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
	
	func convert() {
		guard let from = self.fromCurrencyOption.value, let to = self.toCurrencyOption.value else { return }
	
		self.convertCurrencyUseCase.convert(value: currentValue, from: from, to: to) { (convertedValue) in
			self.convertedValue.value = convertedValue
		}
	}
	
	func set(value: Double) {
		self.currentValue = value
	}
	
	private func getLastUsedFrom(useCase: LastUsedCurrencyOptionsUseCase) {
		self.setFrom(currencyOption: useCase.lastUsedFromCurrencyOption)
		self.setTo(currencyOption: useCase.lastUsedToCurrencyOption)
	}
	
	private func setFrom(currencyOption: CurrencyOption?) {
		self.fromCurrencyOption.value = currencyOption
		self.saveLastUsed()
		self.convert()
	}
	
	private func setTo(currencyOption: CurrencyOption?) {
		self.toCurrencyOption.value = currencyOption
		self.saveLastUsed()
		self.convert()
	}
	
	private func saveLastUsed() {
		guard let from = fromCurrencyOption.value, let to = self.toCurrencyOption.value else { return }
		self.lastUsedCurrencyOptionsUseCase.saveLastUsedCurrencyOptions(
			from: from,
			to: to
		)
	}
}

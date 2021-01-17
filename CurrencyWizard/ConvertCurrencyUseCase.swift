//
//  ConvertCurrencyUseCase.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class ConvertCurrencyUseCase {
	private let currencyService: CurrencyService
	
	init(currencyService: CurrencyService) {
		self.currencyService = currencyService
	}
	
	func convert(value: Double, from fromCurrency: CurrencyOption, to toCurrency: CurrencyOption, completion: @escaping (Double) -> Void) {
		self.currencyService.requestExchangeRate(from: fromCurrency, to: toCurrency) { exchangeRate in
			completion(value * exchangeRate)
		}
	}
}

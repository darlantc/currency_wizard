//
//  CurrencyServiceMock.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
@testable import CurrencyWizard

class CurrencyServiceMock: CurrencyService {
	let options: [CurrencyOption]
	let exchangeRateQuotes: [ExchangeRateQuote]
	let exchangeRateValue: Double
	
	init(options: [CurrencyOption] = [], exchangeRateQuotes: [ExchangeRateQuote] = [], exchangeRateValue: Double = 0) {
		self.options = options
		self.exchangeRateQuotes = exchangeRateQuotes
		self.exchangeRateValue = exchangeRateValue
	}
	
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void) {
		completion(self.options)
	}
	func requestExchangeRateQuotes(completion: @escaping ([ExchangeRateQuote]) -> Void) {
		completion(self.exchangeRateQuotes)
	}
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: (Double) -> Void) {
		completion(self.exchangeRateValue)
	}
}

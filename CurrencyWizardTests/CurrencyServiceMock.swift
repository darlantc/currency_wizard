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
	let exchangeRateValue: Double
	
	init(options: [CurrencyOption] = [], exchangeRateValue: Double = 0) {
		self.options = options
		self.exchangeRateValue = exchangeRateValue
	}
	
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void) {
		completion(self.options)
	}
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: (Double) -> Void) {
		completion(self.exchangeRateValue)
	}
}

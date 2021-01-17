//
//  CurrencyService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

protocol CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption]) -> Void)
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: (Double) -> Void)
}

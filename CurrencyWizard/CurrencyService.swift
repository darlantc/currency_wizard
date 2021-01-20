//
//  CurrencyService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

protocol CurrencyService {
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void)
	func requestExchangeRateQuotes(completion: @escaping([ExchangeRateQuote]) -> Void)
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: @escaping (Double) -> Void)
}

extension CurrencyService {
	func getExchangeRate(origin: String, destination: String, withQuotes quotes: [ExchangeRateQuote]) -> Double {
		if origin == "USD" {
			return self.exchangeRateFromUSD(to: destination, withQuotes: quotes)
		}
		
		return self.exchangeRateFrom(origin, destination: destination, withQuotes: quotes)
	}
	
	func exchangeRateFrom(_ origin: String, destination: String, withQuotes quotes: [ExchangeRateQuote]) -> Double {
		let originToUSDExchangeRate = 1 / exchangeRateFromUSD(to: origin, withQuotes: quotes)
		
		if origin == "USD" {
			return originToUSDExchangeRate
		}
		
		let usdToDestinationExchangeRate = exchangeRateFromUSD(to: destination, withQuotes: quotes)
		return originToUSDExchangeRate * usdToDestinationExchangeRate
	}
	
	func exchangeRateFromUSD(to: String, withQuotes quotes: [ExchangeRateQuote]) -> Double {
		let key = "USD\(to)"
		let quote = quotes.first(where: { $0.id == key })
		return quote?.exchangeRate ?? 0
	}
}

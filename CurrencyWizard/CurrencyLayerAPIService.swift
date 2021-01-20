//
//  CurrencyLayerAPIService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import Foundation

final class CurrencyLayerAPIService: CurrencyService {
	private let accessKey = "3783b6c66289a07b07b3b9c68b322858"
	private let baseURL = "http://api.currencylayer.com/"
	
	private let httpService: HttpService
	
	private let notifyUpdatedExchangeRatesQuotes: ([ExchangeRateQuote]) -> Void
	
	init(httpService: HttpService, notifyUpdatedExchangeRatesQuotes: @escaping ([ExchangeRateQuote]) -> Void) {
		self.httpService = httpService
		self.notifyUpdatedExchangeRatesQuotes = notifyUpdatedExchangeRatesQuotes
	}
	
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void) {
		self.httpService.get(urlString: urlFor(method: "list")) { (statusCode, data, error) in
			guard statusCode == 200, let data = data, let jsonData = self.jsonData(from: data) else {
				completion([])
				return
			}
					
			var resultList = [CurrencyOption]()
			if let currencies = jsonData["currencies"] as? [String: String] {
				for key in currencies.keys {
					guard let name = currencies[key] else { return }
					resultList.append(CurrencyOption(name: name, id: key))
				}
			}
			completion(resultList)
		}
	}
	func requestExchangeRateQuotes(completion: @escaping ([ExchangeRateQuote]) -> Void) {
		self.getQuotes(completion: completion)
	}
	
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: @escaping (Double) -> Void) {
		self.getQuotes { (quotes) in
			var result: Double = 0
			self.notifyUpdatedExchangeRatesQuotes(quotes)
			result = self.getExchangeRate(origin: from.id, destination: to.id, withQuotes: quotes)
			
			completion(result)
		}
	}
	
	private func getQuotes(completion: @escaping ([ExchangeRateQuote]) -> Void) {
		var resultList = [ExchangeRateQuote]()

		self.httpService.get(urlString: urlFor(method: "live")) { (statusCode, data, error) in
			guard statusCode == 200, let data = data, let jsonData = self.jsonData(from: data) else {
				completion(resultList)
				return
			}
			
			if let quotes = jsonData["quotes"] as? [String: Double] {
				for key in quotes.keys {
					let quote = ExchangeRateQuote(id: key, exchangeRate: quotes[key] ?? 0)
					resultList.append(quote)
				}
			}
			
			completion(resultList)
		}
	}
	
	private func urlFor(method: String) -> String {
		return "\(self.baseURL)\(method)?access_key=\(self.accessKey)"
	}
	
	private func jsonData(from data: Data) -> NSDictionary? {
		do {
			if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
				return jsonData
			}
			return nil
		} catch {
			return nil
		}
	}
}

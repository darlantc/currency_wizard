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
	
	init(httpService: HttpService) {
		self.httpService = httpService
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
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: @escaping (Double) -> Void) {
		self.httpService.get(urlString: urlFor(method: "live")) { (statusCode, data, error) in
			guard statusCode == 200, let data = data, let jsonData = self.jsonData(from: data) else {
				completion(0)
				return
			}
			
			var result: Double = 0
			if let quotes = jsonData["quotes"] as? [String: Double] {
				let key = "\(from.id)\(to.id)"
				if let exchangeRate = quotes[key] {
					result = exchangeRate
				}
			}
			
			completion(result)
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

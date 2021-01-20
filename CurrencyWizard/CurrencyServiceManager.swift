//
//  CurrencyServiceManager.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 19/01/21.
//

import Foundation

final class CurrencyServiceManager: CurrencyService {
	let currencyService: CurrencyService
	let localStorageService: LocalStorageService
	
	private var timer: Timer?
	private var currencyOptions = [CurrencyOption]() {
		didSet {
			self.localStorageService.save(currencyOptionsList: currencyOptions)
		}
	}
	private var exchangeRateQuotes = [ExchangeRateQuote]() {
		didSet {
			self.localStorageService.save(exchangeRates: exchangeRateQuotes)
		}
	}
	
	init(
		currencyService: CurrencyService,
		localStorageService: LocalStorageService
	) {
		self.currencyService = currencyService
		self.localStorageService = localStorageService
		
		self.getDataFromCache(service: localStorageService)
		self.refreshCache()
		self.startRevalidatingTimer()
	}
	
	func requestCurrencyOptions(completion: @escaping ([CurrencyOption]) -> Void) {
		if self.currencyOptions.isEmpty {
			self.refreshCache()
		}
		completion(self.currencyOptions)
	}
	
	func requestExchangeRateQuotes(completion: @escaping ([ExchangeRateQuote]) -> Void) {
		if self.exchangeRateQuotes.isEmpty {
			self.refreshCache()
		}
		completion(self.exchangeRateQuotes)
	}
	
	func requestExchangeRate(from: CurrencyOption, to: CurrencyOption, completion: @escaping (Double) -> Void) {
		let exchangeRate = self.getExchangeRate(
			origin: from.id,
			destination: to.id,
			withQuotes: self.exchangeRateQuotes
		)
		completion(exchangeRate)
	}
	
	private func getDataFromCache(service: LocalStorageService) {
		service.requestCurrencyOptions { (currencyOptions) in
			self.currencyOptions = currencyOptions
		}
		
		service.requestExchangeRateQuotes { (exchangeRateQuotes) in
			self.exchangeRateQuotes = exchangeRateQuotes
		}
	}
	
	private func startRevalidatingTimer() {
		self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(refreshCache), userInfo: nil, repeats: true)
	}
	
	@objc func refreshCache() {
		self.currencyService.requestCurrencyOptions { (currencyOptions) in
			self.currencyOptions = currencyOptions
		}
		
		self.currencyService.requestExchangeRateQuotes { (exchangeRateQuotes) in
			self.exchangeRateQuotes = exchangeRateQuotes
		}
	}
	
	deinit {
		self.timer?.invalidate()
	}
}

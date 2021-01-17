//
//  RequestCurrencyOptionsUseCase.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class RequestCurrencyOptionsUseCase {
	private let currencyService: CurrencyService
	
	init(currencyService: CurrencyService) {
		self.currencyService = currencyService
	}
	
	func request(completion: @escaping ([CurrencyOption], String?) -> Void) {
		self.currencyService.requestCurrencyOptions { options in
			guard !options.isEmpty else {
				completion([], "Failed to list currency options. Please try again.")
				return
			}
			completion(options, nil)
		}
	}
}

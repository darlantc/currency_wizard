//
//  SelectCurrencyOptionViewModel.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class SelectCurrencyOptionViewModel {
	var currencyOptionsList = [CurrencyOption]()
	private let requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase
	
	init(requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase) {
		self.requestCurrencyOptionsUseCase = requestCurrencyOptionsUseCase
	}
	
	func requestCurrencyOptions() {
		self.requestCurrencyOptionsUseCase.request { (currencyOptions, error) in
			guard error == nil else { return }
			
			self.currencyOptionsList = currencyOptions
		}
	}
}

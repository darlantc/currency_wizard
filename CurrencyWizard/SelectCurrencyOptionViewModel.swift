//
//  SelectCurrencyOptionViewModel.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class SelectCurrencyOptionViewModel {
	private let didFinish: (CurrencyOption) -> Void
	private let requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase
		
	private var selectedIndex: Int? = nil
	var currencyOptionsList = [CurrencyOption]()
	
	init(
		requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase,
		didFinish: @escaping (CurrencyOption) -> Void
	) {
		self.requestCurrencyOptionsUseCase = requestCurrencyOptionsUseCase
		self.didFinish = didFinish
	}
	
	func requestCurrencyOptions() {
		self.requestCurrencyOptionsUseCase.request { (currencyOptions, error) in
			guard error == nil else { return }
			
			self.currencyOptionsList = currencyOptions
		}
	}
	
	func didSelect(at index: Int) {
		guard self.currencyOptionsList.count > index else {
			self.selectedIndex = nil
			return
		}
		self.selectedIndex = index
	}
	
	func didFinishWithSelected() {
		guard let index = self.selectedIndex, self.currencyOptionsList.count > index else { return }
		
		self.didFinish(self.currencyOptionsList[index])
	}
}

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
	let isLoading: Observable<Bool> = Observable(false)
	let currencyOptionsList = Observable([CurrencyOption]())
	
	init(
		requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase,
		didFinish: @escaping (CurrencyOption) -> Void
	) {
		self.requestCurrencyOptionsUseCase = requestCurrencyOptionsUseCase
		self.didFinish = didFinish
	}
	
	func requestCurrencyOptions() {
		self.setIsLoading(true)
		self.requestCurrencyOptionsUseCase.request { (currencyOptions, error) in
			guard error == nil else {
				self.setIsLoading(true)
				return
			}
			
			self.currencyOptionsList.value = currencyOptions
			self.setIsLoading(false)
		}
	}
	
	func didSelect(at index: Int) {
		guard self.currencyOptionsList.value.count > index else {
			self.selectedIndex = nil
			return
		}
		self.selectedIndex = index
	}
	
	func didFinishWithSelected() {
		guard let index = self.selectedIndex, self.currencyOptionsList.value.count > index else { return }
		
		self.didFinish(self.currencyOptionsList.value[index])
	}
	
	private func setIsLoading(_ value: Bool) {
		self.isLoading.value = value
	}
}
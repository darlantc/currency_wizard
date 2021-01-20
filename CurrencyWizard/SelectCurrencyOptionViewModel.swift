//
//  SelectCurrencyOptionViewModel.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation

final class SelectCurrencyOptionViewModel {
	private let didFinish: ((CurrencyOption) -> Void)?
	private let requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase
		
	private var selectedIndex: Int? = nil
	private (set) var searchString: Observable<String> = Observable("")
	let headerText: String
	let isLoading: Observable<Bool> = Observable(false)
	let currencyOptionsList = Observable([CurrencyOption]())
	var filteredCurrencyOptionsList: [CurrencyOption] {
		if searchString.value.isEmpty {
			return self.currencyOptionsList.value
		}
		return self.currencyOptionsList.value.filter {
			return $0.id.lowercased().contains(searchString.value) ||
				$0.name.lowercased().contains(searchString.value)
		}
	}
	
	init(
		headerText: String,
		requestCurrencyOptionsUseCase: RequestCurrencyOptionsUseCase,
		didFinish: ((CurrencyOption) -> Void)?
	) {
		self.headerText = headerText
		self.requestCurrencyOptionsUseCase = requestCurrencyOptionsUseCase
		self.didFinish = didFinish
	}
	
	func requestCurrencyOptions() {
		self.setIsLoading(true)
		self.requestCurrencyOptionsUseCase.request { (currencyOptions, error) in
			guard error == nil else {
				self.setIsLoading(false)
				return
			}
			
			self.currencyOptionsList.value = currencyOptions.sorted { $0.name < $1.name }
			self.setIsLoading(false)
		}
	}
	
	func didSelect(at index: Int) {
		guard self.filteredCurrencyOptionsList.count > index else {
			self.selectedIndex = nil
			return
		}
		self.selectedIndex = index
	}
	
	func didFinishWithSelected() {
		guard let index = self.selectedIndex, self.filteredCurrencyOptionsList.count > index else { return }
		
		self.didFinish?(self.filteredCurrencyOptionsList[index])
	}
	
	func didSearch(_ query: String) {
		self.searchString.value = query.lowercased()
	}
	
	private func setIsLoading(_ value: Bool) {
		self.isLoading.value = value
	}
}

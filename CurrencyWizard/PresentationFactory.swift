//
//  PresentationFactory.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import UIKit

final class PresentationFactory {
	let navigationController: UINavigationController
	let currencyService: CurrencyService
	let localStorageService: LocalStorageService
	
	init(navigationController: UINavigationController, currencyService: CurrencyService, localStorageService: LocalStorageService) {
		self.navigationController = navigationController
		self.currencyService = currencyService
		self.localStorageService = localStorageService
	}

	func displayConvertCurrenciesViewController() {
		let convertCurrencyUseCase = ConvertCurrencyUseCase(currencyService: self.currencyService)
		let lastUsedCurrencyOptionsUseCase = LastUsedCurrencyOptionsUseCase(localStorageService: self.localStorageService)
		
		let viewModel = ConvertCurrenciesViewModel(
			convertCurrencyUseCase: convertCurrencyUseCase,
			lastUsedCurrencyOptionsUseCase: lastUsedCurrencyOptionsUseCase
		) { (completion) in
			let selectCurrencyOptionViewController = self.displaySelectCurrencyOptionViewController(
				headerText: "Selecione a moeda"
			) { (currencyOption) in
				completion(currencyOption)
				self.navigationController.popViewController(animated: true)
			}
			self.navigationController.pushViewController(selectCurrencyOptionViewController, animated: true)
		}
		let viewController = ConvertCurrenciesViewController(viewModel: viewModel)
		self.navigationController.pushViewController(viewController, animated: true)
	}
	
	func displaySelectCurrencyOptionViewController(
		headerText: String,
		didFinish: ((CurrencyOption) -> Void)?
	) -> SelectCurrencyOptionViewController {
		let requestCurrencyOptionsUseCase = RequestCurrencyOptionsUseCase(currencyService: self.currencyService)
		
		let viewModel = SelectCurrencyOptionViewModel(
			headerText: headerText,
			requestCurrencyOptionsUseCase: requestCurrencyOptionsUseCase,
			didFinish: didFinish
		)
		let viewController = SelectCurrencyOptionViewController(viewModel: viewModel)
		
		return viewController
	}
}

//
//  AppDelegate.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 16/01/21.
//

import UIKit

private class LocalStorageServiceMock: LocalStorageService {
	fileprivate var currencyOptionsList = [CurrencyOption]()
	private var idsList: [String]
	private let didCallListener: ((String) -> Void)?
	private var lastUsedFromCurrencyOption: CurrencyOption?
	private var lastUsedToCurrencyOption: CurrencyOption?
	
	init(
		idsList: [String] = [],
		didCallListener: ((String) -> Void)? = nil,
		lastUsedFromCurrencyOption: CurrencyOption? = nil,
		lastUsedToCurrencyOption: CurrencyOption? = nil
	) {
		self.idsList = idsList
		self.didCallListener = didCallListener
		self.lastUsedFromCurrencyOption = lastUsedFromCurrencyOption
		self.lastUsedToCurrencyOption = lastUsedToCurrencyOption
	}
	
	func requestLastUsedCurrencyOptions(completion: ((from: CurrencyOption, to: CurrencyOption)?) -> Void) {
		self.didCallListener?("requestLastUsedCurrencyOptions")
		
		guard let from = self.lastUsedFromCurrencyOption, let to = self.lastUsedToCurrencyOption else {
			completion(nil)
			return
		}
		completion((from, to))
	}
	
	func saveLastUsedCurrencyOptions(from fromCurrencyOption: CurrencyOption, to toCurrencyOption: CurrencyOption) {
		self.didCallListener?("saveLastUsedCurrencyOptions")
		
		self.lastUsedFromCurrencyOption = fromCurrencyOption
		self.lastUsedToCurrencyOption = toCurrencyOption
	}
	
	func save(currencyOptionsList: [CurrencyOption]) {
		self.currencyOptionsList = currencyOptionsList
		self.didCallListener?("requestLastUsedCurrencyOptions")
	}
	
	func save(exchangeRates: [String: Double]) {
		self.didCallListener?("save(exchangeRates:)")
	}
	
	func requestFavoriteCurrencyOptionIds(completion: ([String]) -> Void) {
		self.didCallListener?("requestFavoriteCurrencyOptionIds")
		completion(self.idsList)
	}
	
	func favorite(currencyOption: CurrencyOption) {
		self.didCallListener?("favorite(currencyOption:)")
		self.idsList.append(currencyOption.id)
	}
	
	func removeFavorite(currencyOption: CurrencyOption) {
		self.didCallListener?("removeFavorite(currencyOption:)")
		self.idsList = self.idsList.filter { $0 != currencyOption.id }
	}
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)

		
		let httpService: HttpService = URLSessionHttpService()
		let currencyLayerAPIService = CurrencyLayerAPIService(httpService: httpService) { _ in }
		
		let navigationController = UINavigationController()
		
		let currencyService: CurrencyService = currencyLayerAPIService
		let localStorageService: LocalStorageService = LocalStorageServiceMock(
			idsList: [],
			lastUsedFromCurrencyOption: CurrencyOption(name: "United States Dollar", id: "USD"),
			lastUsedToCurrencyOption: CurrencyOption(name: "Euro", id: "EUR")
		)
		
		let factory = PresentationFactory(
			navigationController: navigationController,
			currencyService: currencyService,
			localStorageService: localStorageService
		)
		
		factory.displayConvertCurrenciesViewController()
		
		window.rootViewController = navigationController
		self.window = window
		window.makeKeyAndVisible()
		
		return true
	}
}


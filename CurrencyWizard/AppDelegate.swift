//
//  AppDelegate.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 16/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		
		let httpService: HttpService = URLSessionHttpService()
		let currencyAPIService: CurrencyService = CurrencyLayerAPIService(httpService: httpService)
		let localStorageService: LocalStorageService = UserDefaultsStorageService()
		let currencyService: CurrencyService = CurrencyServiceManager(
			currencyService: currencyAPIService,
			localStorageService: localStorageService
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


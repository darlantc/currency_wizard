//
//  SelectCurrencyOptionViewControllerTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import XCTest
@testable import CurrencyWizard

class SelectCurrencyOptionViewControllerTests: UIViewControllerXCTestCase {
    func test_initSUT_withoutOptions_shouldHaveEmptyTableView() {
        let sut = makeSUT(options: [])
		XCTAssertEqual(sut.tableView?.numberOfRows(), 0)
    }
	
	func test_initSUT_withOptions_shouldHaveCells() {
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		waitForLoadingExpectation()
		
		XCTAssertEqual(sut.tableView?.numberOfRows(), 2)
	}
	
	func test_tableViewCell_displayCorrectValues() {
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		waitForLoadingExpectation()
		
		XCTAssertEqual(sut.tableView.title(at: 0), "\(usdCurrencyOption.id) - \(usdCurrencyOption.name)")
		XCTAssertEqual(sut.tableView.title(at: 1), "\(eurCurrencyOption.id) - \(eurCurrencyOption.name)")
	}

	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(
		options: [CurrencyOption] = []
	) -> SelectCurrencyOptionViewController {
		let viewModel = makeViewModel(options: options)
		let sut = SelectCurrencyOptionViewController(viewModel: viewModel)
		let _ = sut.view
		return sut
	}
	
	func makeViewModel(
		options: [CurrencyOption] = [],
		didFinish: @escaping (CurrencyOption) -> Void = { _ in }
	) -> SelectCurrencyOptionViewModel {
		let currencyService = CurrencyServiceMock(options: options)
		let requestCurrencyOptionsUseCase = RequestCurrencyOptionsUseCase(currencyService: currencyService)
		return SelectCurrencyOptionViewModel(
			requestCurrencyOptionsUseCase: requestCurrencyOptionsUseCase,
			didFinish: didFinish
		)
	}
}

private extension UITableView {
	func numberOfRows() -> Int {
		self.numberOfRows(inSection: 0)
	}
	
	func title(at row: Int) -> String? {
		return cell(at: row)?.textLabel?.text
	}
	
	func cell(at row: Int) -> UITableViewCell? {
		return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
	}
}

//
//  SelectCurrencyOptionViewControllerTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import XCTest
@testable import CurrencyWizard

class SelectCurrencyOptionViewControllerTests: UIViewControllerXCTestCase {
	func test_initSUT_withHeaderText_shouldDisplayHeaderText() {
		let sut = makeSUT(headerText: "Please select")
		XCTAssertEqual(sut.headerLabel.text, "Please select")
	}
	
    func test_initSUT_withoutOptions_shouldHaveEmptyTableView() {
        let sut = makeSUT(options: [])
		waitForLoadingExpectation()

		XCTAssertEqual(sut.tableView?.numberOfRows(), 0)
    }
	
	func test_initSUT_witOptions_shouldDisplayLoadingAnimation() {
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption])
		waitForLoadingExpectation()
		XCTAssertTrue(sut.loadingView.isHidden)
		XCTAssertFalse(sut.tableView.isHidden)
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
	
	func test_selectTableViewRow_didFinishViewModelWithSelectedCurrencyOption() {
		var selectedCurrencyOption: CurrencyOption? = nil
		
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption], didFinish: { currencyOption in
			selectedCurrencyOption = currencyOption
		})
		waitForLoadingExpectation()
		
		sut.tableView.select(row: 0)
		XCTAssertEqual(selectedCurrencyOption, usdCurrencyOption)
		
		sut.tableView.select(row: 1)
		XCTAssertEqual(selectedCurrencyOption, eurCurrencyOption)
	}
	
	func test_selectWrongTableViewRow_doesNothing() {
		var selectedCurrencyOption: CurrencyOption? = nil
		
		let sut = makeSUT(options: [usdCurrencyOption, eurCurrencyOption], didFinish: { currencyOption in
			selectedCurrencyOption = currencyOption
		})
		waitForLoadingExpectation()

		sut.tableView.select(row: 4)
		XCTAssertNil(selectedCurrencyOption)
	}

	// MARK: Helpers
	private let usdCurrencyOption = CurrencyOption(name: "United States Dollar", id: "USD")
	private let eurCurrencyOption = CurrencyOption(name: "Euro", id: "EUR")

	func makeSUT(
		headerText: String = "",
		options: [CurrencyOption] = [],
		didFinish: @escaping (CurrencyOption) -> Void = { _ in }
	) -> SelectCurrencyOptionViewController {
		let viewModel = makeViewModel(headerText: headerText, options: options, didFinish: didFinish)
		let sut = SelectCurrencyOptionViewController(viewModel: viewModel)
		let _ = sut.view
		
		return sut
	}
	
	func makeViewModel(
		headerText: String = "",
		options: [CurrencyOption] = [],
		didFinish: @escaping (CurrencyOption) -> Void = { _ in }
	) -> SelectCurrencyOptionViewModel {
		let currencyService = CurrencyServiceMock(options: options)
		let requestCurrencyOptionsUseCase = RequestCurrencyOptionsUseCase(currencyService: currencyService)
		return SelectCurrencyOptionViewModel(
			headerText: headerText,
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
	
	func select(row: Int) {
		let indexPath = IndexPath(row: row, section: 0)
		selectRow(at: indexPath, animated: false, scrollPosition: .none)
		delegate?.tableView?(self, didSelectRowAt: indexPath)
	}
}

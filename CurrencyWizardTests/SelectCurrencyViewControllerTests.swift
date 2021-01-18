//
//  SelectCurrencyOptionViewControllerTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import XCTest
@testable import CurrencyWizard

class SelectCurrencyOptionViewControllerTests: XCTestCase {
    func test_initSUT_shouldHaveEmptyTableView() throws {
        let sut = makeSUT()
		XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 0)
    }

	// MARK: Helpers
	func makeSUT() -> SelectCurrencyOptionViewController {
		let sut = SelectCurrencyOptionViewController()
		let _ = sut.view
		return sut
	}
}

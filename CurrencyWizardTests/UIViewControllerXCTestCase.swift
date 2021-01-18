//
//  UIViewControllerXCTestCase.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 17/01/21.
//

import Foundation
import XCTest

class UIViewControllerXCTestCase: XCTestCase {
	func waitForLoadingExpectation() {
		let expectation = self.expectation(description: "loading")
		expectation.isInverted = true
		waitForExpectations(timeout: 1.0, handler: nil)
	}
	
	func touchUpInside(button: UIButton?) {
		button?.sendActions(for: .touchUpInside)
		
		let expectation = self.expectation(description: "touch Button")
		expectation.isInverted = true
		waitForExpectations(timeout: 1.0, handler: nil)
	}
}

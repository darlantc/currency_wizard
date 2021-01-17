//
//  CurrencyServiceTests.swift
//  CurrencyWizardTests
//
//  Created by Darlan Tódero ten Caten on 16/01/21.
//

import Foundation
import XCTest
@testable import CurrencyWizard

struct CurrencyOption {
	let name: String
	let id: String
	let isFavorite: Bool
}

protocol CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption]))
}

class CurrencyServiceTests: XCTestCase {
	func test_initSUT_shouldNotRequestAnything() {
		let sut = CurrencyServiceStub()
		
		XCTAssertEqual(sut.internalCalls, [])
	}
}

private class CurrencyServiceStub: CurrencyService {
	func requestCurrencyOptions(completion: ([CurrencyOption])) {
		
	}
	
	var internalCalls = [String]()
	func didCall(function name: String) {
		self.internalCalls.append(name)
	}
}

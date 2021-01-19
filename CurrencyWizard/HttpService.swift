//
//  HttpService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import Foundation

protocol HttpService {
	func get(urlString: String, completion: @escaping(Int, Data?, Error?) -> Void)
}

//
//  URLSessionHttpService.swift
//  CurrencyWizard
//
//  Created by Darlan Tódero ten Caten on 18/01/21.
//

import Foundation

final class URLSessionHttpService: HttpService {
	func get(urlString: String, completion: @escaping(Int, Data?, Error?) -> Void) {
		guard let url = URL(string: urlString) else {
			return
		}
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(500, nil, NSError(domain: "Invalid URL", code: 500, userInfo: nil))
				return
			}
			
			completion(
				httpResponse.statusCode,
				data,
				error
			)
		}.resume()
	}
}

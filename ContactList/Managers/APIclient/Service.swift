//
//  Service.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import Foundation

class Service {
	
	static let shared = Service()
		
	private init() {}
	
	@frozen enum ServiceErrors: Error {
		case failedToGetData
		case URLError
	}
	
	
	/// Fetch data from reqres api
	/// - Parameter completion: Return Contact when success, Error when fail
	func fetchContactsData(completion: @escaping (Result<[Contact], Error>) -> Void) {
		var allContacts: [Contact] = []
		var page = 1

		func fetchPage() {
			guard let url = URL(string: "https://reqres.in/api/users?page=\(page)") else {
				completion(.failure(ServiceErrors.URLError))
				return
			}

			let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
				guard let data = data, error == nil else {
					completion(.failure(ServiceErrors.failedToGetData))
					return
				}

				do {
					let JSONresponse = try JSONDecoder().decode(ContactListResponse.self, from: data)
					let contacts = JSONresponse.data
					allContacts.append(contentsOf: contacts)

					if JSONresponse.page < JSONresponse.total_pages {
						// Fetch next page
						page += 1
						fetchPage()
					} else {
						// When all pages fetched, return the result
						completion(.success(allContacts))
					}
				} catch {
					completion(.failure(ServiceErrors.failedToGetData))
				}
			}

			task.resume()
		}

		fetchPage()
	}
}

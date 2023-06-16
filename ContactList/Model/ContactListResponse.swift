//
//  ContactListResponse.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import Foundation

struct ContactListResponse: Codable {
	let data: [Contact]
	let total_pages: Int
	let page: Int
}

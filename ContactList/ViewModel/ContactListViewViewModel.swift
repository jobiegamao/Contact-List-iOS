//
//  ContactListViewViewModel.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import Foundation
import UIKit

protocol ContactListViewViewModelDelegate: AnyObject {
	func didAddToListTable()
	func didTapCell(selected contact: Contact)
}

class ContactListViewViewModel: NSObject {
	
	weak var delegate: ContactListViewViewModelDelegate?
	private var contacts: [Contact] = [] {
		didSet {
			contacts = contacts.sorted { $0.first_name < $1.first_name }
			tableSections = Array(Set(contacts.compactMap { $0.first_name.first })).sorted()
		}
	}
	private var tableSections: [Character] = []
	

	// MARK: - Public Methods
	
	/// Initial Retrieval of Contact List
	func fetchContacts() {
		// get contacts from coredata
		contacts = DataPersistenceManager.shared.fetchContacts()
		
		// if empty, fetch from API
		// then save in DataPersistenceManager
		if contacts.isEmpty {
			Service.shared.fetchContactsData { [weak self] result in
				switch result {
					case .success(let success):
						self?.contacts = success
						DataPersistenceManager.shared.saveContacts(success)
						// delegate load tableview
						self?.delegate?.didAddToListTable()
					case .failure(let failure):
						print("Failed to fetch contacts: \(failure)")
				}
			}
		} else {
			// delegate load tableview
			delegate?.didAddToListTable()
		}
	}
	
	// MARK: - Private Methods
	private func contacts(inSection section: Int) -> [Contact] {
		let contactsInSection = contacts.filter({
			$0.first_name.first?.lowercased() == tableSections[section].lowercased()
		})
		return contactsInSection
	}
}

/// TableView Configurations
extension ContactListViewViewModel: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableSections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts(inSection: section).count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return String(tableSections[section])
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "ListTableViewCell",
			for: indexPath
		)
				
		let contact = contacts(inSection: indexPath.section)[indexPath.row]
		cell.textLabel?.text = "\(contact.first_name) \(contact.last_name)"
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let contact = contacts(inSection: indexPath.section)[indexPath.row]
		delegate?.didTapCell(selected: contact)
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
}


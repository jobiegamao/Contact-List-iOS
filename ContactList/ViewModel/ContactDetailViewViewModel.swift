//
//  ContactDetailViewViewModel.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import Foundation

class ContactDetailViewViewModel {
	private var selectedContact: Contact
	var fullName: String {
		selectedContact.first_name + " " + selectedContact.last_name
	}
	var email: String {
		selectedContact.email
	}
	var avatar: URL? {
		URL(string: selectedContact.avatar)
	}
	
	init(of selectedContact: Contact) {
		self.selectedContact = selectedContact
	}
}

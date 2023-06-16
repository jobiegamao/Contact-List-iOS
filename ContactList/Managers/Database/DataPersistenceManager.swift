//
//  DataPersistenceManager.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import Foundation
import CoreData

class DataPersistenceManager{
	static let shared = DataPersistenceManager()
		
	private init() {}
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ContactList")
		container.loadPersistentStores { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		}
		return container
	}()
	
	func saveContacts(_ contacts: [Contact]) {
		let context = persistentContainer.viewContext
				
		for contact in contacts {
			let contactEntity = ContactEntity(context: context)
			
			contactEntity.id = Int64(contact.id)
			contactEntity.avatar = contact.avatar
			contactEntity.first_name = contact.first_name
			contactEntity.last_name = contact.last_name
			contactEntity.email = contact.email
			
		}
		
		do {
			try context.save()
		} catch {
			print("Failed to save contacts to Core Data: \(error)")
		}

	}
	
	func fetchContacts() -> [Contact] {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
		
		do {
			let contactEntities = try context.fetch(fetchRequest)
			
			let contacts = contactEntities.map { contactEntity -> Contact in
				let id = Int(contactEntity.id)
				let avatar = contactEntity.avatar ?? ""
				let first_name = contactEntity.first_name ?? ""
				let last_name = contactEntity.last_name ?? ""
				let email = contactEntity.email ?? ""
				
				return Contact(
					id: id,
					email: email,
					first_name: first_name,
					last_name: last_name,
					avatar: avatar
				)
			}
			
			return contacts
		} catch {
			print("Failed to fetch contacts from Core Data: \(error)")
			return []
		}
	}
}

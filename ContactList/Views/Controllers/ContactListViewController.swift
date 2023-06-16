//
//  ViewController.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import UIKit

class ContactListViewController: UIViewController {

	private let viewModel = ContactListViewViewModel()
	private var selectedContact: Contact?
	
	@IBOutlet weak var listTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		navigationItem.largeTitleDisplayMode = .always
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Contact List"
		
		listTableView.delegate = viewModel
		listTableView.dataSource = viewModel
		
		viewModel.delegate = self
		viewModel.fetchContacts()
		
	}
	
	
   /// brings data to other VC
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowContactDetailViewController" {
			if let destinationVC = segue.destination as? ContactDetailViewController {
				destinationVC.selectedContact = selectedContact
			}
		}
	}

}

/// ViewModel Delegate
extension ContactListViewController: ContactListViewViewModelDelegate {
	func didTapCell(selected contact: Contact) {
		DispatchQueue.main.async { [weak self] in
			self?.selectedContact = contact
			self?.performSegue(withIdentifier: "ShowContactDetailViewController", sender: self)
		}
	}
	
	func didAddToListTable() {
		DispatchQueue.main.async { [weak self] in
			self?.listTableView.reloadData()
		}
	}
	
	
}

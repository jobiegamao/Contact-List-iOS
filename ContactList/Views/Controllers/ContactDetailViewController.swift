//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by may on 6/15/23.
//

import UIKit
import SDWebImage

class ContactDetailViewController: UIViewController {

	public var selectedContact: Contact?
	private var viewModel: ContactDetailViewViewModel!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var emailLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		viewModel = ContactDetailViewViewModel(of: selectedContact!)
		configureUI()
		
    }
    

	// MARK: - Private Methods
	private func configureUI(){
		guard let viewModel = viewModel else { return }
		
		if let avatarURL = viewModel.avatar {
			imageView.sd_setImage(with: avatarURL, completed: nil)
		}
		imageView.layer.cornerRadius = imageView.frame.height / 2
		imageView.clipsToBounds = true
	
		
		nameLbl.text = viewModel.fullName
		emailLbl.text = viewModel.email
	}
	
	

}

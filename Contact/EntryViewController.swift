//
//  EntryViewController.swift
//  Contact
//
//  Created by Babita Rawat on 2023-08-12.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var phoneField: UITextField!
    var contacts: [Contact] = []
    public var contact: Contact?
    public var completion :((String, String, String)-> Void)?
    override func viewDidLoad() {
      
        super.viewDidLoad()
        // Set the initial values for text fields using the 'contact' data
        nameField.text = contact?.name
        emailField.text = contact?.email
        phoneField.text = contact?.mobileNumber

        nameField.becomeFirstResponder()
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        // Set the color of the Save button
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        // Set the color of the back button
        navigationController?.navigationBar.tintColor = UIColor.orange
        // Set placeholders for text fields
               nameField.placeholder = "Name"
               emailField.placeholder = "Email (Optional)"
               phoneField.placeholder = "Phone"
    }

    @objc func didTapSave() {
         if let name = nameField.text, !name.isEmpty,
            let phone = phoneField.text, !phone.isEmpty {
             let newContact = Contact(name: name, email: emailField.text ?? "", mobileNumber: phone)
             contacts.append(newContact) // Append the new contact to the items array
             completion?(name, emailField.text ?? "", phone)
         }
     }
   
}

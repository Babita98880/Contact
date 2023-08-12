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
    public var completion :((String, String, String)-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    @objc func didTapSave(){
        if let name = nameField.text, !name.isEmpty,
           let phone = phoneField.text, !phone.isEmpty {
            completion?(name, emailField.text ?? "", phone)
        }
    }
   
}

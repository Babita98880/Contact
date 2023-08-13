//
//  ViewController.swift
//  Contact
//
//  Created by Babita Rawat on 2023-08-12.
//
import UIKit
//Declaration
struct Contact: Codable {
    var name: String
    var email: String
    var mobileNumber:String
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    var contacts: [Contact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        table.delegate = self
        table.dataSource = self
        loadStoredContacts()
    }
    
    // Load initial contacts
    func loadStoredContacts() {
        contacts.removeAll()
        if let storedData = UserDefaults.standard.data(forKey: "items") {
                   do {
                       contacts = try JSONDecoder().decode([Contact].self, from: storedData)

                       updateEmptyState()
                       table.reloadData()
                   } catch let err {
                       print("Error decoding stored items: \(err)")
                   }
               }
           
    }
    
    // Update empty state message
    func updateEmptyState() {
        if contacts.isEmpty {
            label.text = "No contacts yet"
            label.isHidden = false
            table.isHidden = true
        } else {
            label.isHidden = true
            table.isHidden = false
        }
    }
    @IBAction func didTapNewContact() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as? EntryViewController {
            vc.title = "New Contact"
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.contacts = contacts // Pass the items array to EntryViewController
            vc.completion = { [weak self] contactName, contactEmail, contactPhone in
                guard let self = self else { return }
                vc.navigationController?.popToRootViewController(animated: true)
                self.contacts.append(Contact(name: contactName, email: contactEmail, mobileNumber: contactPhone))
//                self.contacts.append((contactName, contactEmail, contactPhone))
                self.updateEmptyState()
                self.table.reloadData()
                self.saveItemsToUserDefaults() // Save the updated items array
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }



    // Save items to UserDefaults
        func saveItemsToUserDefaults() {
            if let encoded = try? JSONEncoder().encode(contacts) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].name
        cell.detailTextLabel?.text = contacts[indexPath.row].mobileNumber
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = contacts[indexPath.row]
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contact") as? ContactViewController {
            vc.title = "Contact"
            vc.nameTitle = model.name
            vc.emailTitle = model.email
            vc.mobileTitle = model.mobileNumber
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editContact(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteContact(at: indexPath)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }

    func editContact(at indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as? EntryViewController {
            vc.title = "Edit Contact"
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.nameField.text = contact.name
            vc.emailField.text = contact.email
            vc.phoneField.text = contact.mobileNumber
            vc.completion = { [weak self] contactName, contactEmail, contactPhone in
                guard let self = self else { return }
                vc.navigationController?.popToRootViewController(animated: true)
                // Create a new Contact instance with the updated data
                let updatedContact = Contact(name: contactName, email: contactEmail, mobileNumber: contactPhone)
                self.contacts[indexPath.row] = updatedContact // Update the array
                self.table.reloadData()
                self.updateEmptyState()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

//    func deleteContact(at indexPath: IndexPath) {
//        contacts.remove(at: indexPath.row)
//        table.deleteRows(at: [indexPath], with: .fade)
//        updateEmptyState()
//        saveContactsToUserDefaults()
//    }
    func deleteContact(at indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        
        let alertController = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.performDeleteContact(at: indexPath)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
  
    private func performDeleteContact(at indexPath: IndexPath) {
        contacts.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        updateEmptyState()
        saveContactsToUserDefaults()
    }

//    func saveContactsToUserDefaults() {
//        var contactsDict: [String: [String: Any]] = [:]
//        for (index, contact) in contacts.enumerated() {
//            let contactDict: [String: Any] = [
//                "name": contact.name,
//                "email": contact.email,
//                "phone": contact.mobileNumber
//            ]
//            contactsDict["contact_\(index)"] = contactDict
//            print(contactsDict)
//        }
//        UserDefaults.standard.set(contactsDict, forKey: "contacts")
//    }
    func saveContactsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(contacts) {
             UserDefaults.standard.set(encoded, forKey: "items")
         }
    }
}

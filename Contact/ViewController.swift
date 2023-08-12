//
//  ViewController.swift
//  Contact
//
//  Created by Babita Rawat on 2023-08-12.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    @IBOutlet var label:UILabel!
    var models : [(name: String, email:String, mobileNumber:String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        table.delegate = self
        table.dataSource = self
        loadInitialContacts()
    }
    // Load initial contacts
      func loadInitialContacts() {
          models = [
              ("John Doe", "john@example.com", "123-456-7890"),
              ("Jane Smith", "jane@example.com", "987-654-3210")
          ]
          table.reloadData()
      }
    @IBAction func didTapNewContact(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as? EntryViewController {
            vc.title = "New Contact"
            vc.navigationItem.largeTitleDisplayMode = .never
           
            vc.completion = { [weak self] contactName, contactEmail, contactPhone in
                guard let self = self else { return } // Unwrap and assign self to a non-optional local variable
                vc.navigationController?.popToRootViewController(animated: true)
                self.models.append((contactName, contactEmail, contactPhone))
                self.label.isHidden = true
                self.table.isHidden = false
                self.table.reloadData()
            }

            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        cell.detailTextLabel?.text = models[indexPath.row].mobileNumber
        print(cell)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        //Show contact controller
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contact") as? ContactViewController {
            vc.title = "Contact"
            vc.nameTitle = model.name
            vc.emailTitle = model.email
            vc.mobileTitle = model.mobileNumber
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}

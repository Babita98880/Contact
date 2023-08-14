//
//  ContactViewController.swift
//  Contact
//
//  Created by Babita Rawat on 2023-08-12.
//

import UIKit

class ContactViewController: UIViewController {
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var mobileLabel:UILabel!
    @IBOutlet var emailLabel:UILabel!
    public var nameTitle: String = ""
    public var mobileTitle: String = ""
    public var emailTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameTitle
        mobileLabel.text = mobileTitle
        emailLabel.text = emailTitle
        // Set the color of the Save button
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        // Set the color of the back button
        navigationController?.navigationBar.tintColor = UIColor.orange
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

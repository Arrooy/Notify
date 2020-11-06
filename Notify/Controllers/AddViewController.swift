//
//  AddViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButtonActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonActionHandler(_ sender: Any) {
        
    }
    
}
